// TOOD: 404's a resource, why?
import { FaceLandmarker, FilesetResolver, DrawingUtils } from "https://cdn.jsdelivr.net/npm/@mediapipe/tasks-vision@0.10.3";

let isDebugMode = true;
let isActiveAI = false;

const windowElementPage = document.getElementById("page")
const windowElementDebug = document.getElementById("debug")
const windowElementVideo = document.getElementById("webcam");
const windowElementCanvas = document.getElementById("output_canvas");
const videoBlendShapes = document.getElementById("video-blend-shapes");

const canvasCtx = windowElementCanvas.getContext("2d");
const drawingUtils = new DrawingUtils(canvasCtx);

function initializeVideoCanvas() {
    const videoWidth = 480;
    const ratio = windowElementVideo.videoHeight / windowElementVideo.videoWidth;
    windowElementVideo.style.width = videoWidth + "px";
    windowElementVideo.style.height = videoWidth * ratio + "px";
    windowElementCanvas.style.width = videoWidth + "px";
    windowElementCanvas.style.height = videoWidth * ratio + "px";
    windowElementCanvas.width = windowElementVideo.videoWidth;
    windowElementCanvas.height = windowElementVideo.videoHeight;
}

let aiFaceLandmarker = undefined;
windowElementDebug.addEventListener("click", toggleDebugMode)

function toggleDebugMode() {
    isDebugMode = !isDebugMode;
    console.log("Toggled DEBUG: ", isDebugMode)

    if (isDebugMode) {
        windowElementDebug.classList.remove("invisible") 
    } else {
        windowElementDebug.classList.add("invisible")
    }
}

function pageSupportsWebcam() {
    return !!(navigator.mediaDevices && navigator.mediaDevices.getUserMedia);
}

function onBlink() {
    console.log("Started Blinking!")
    windowElementPage.style.transition = "background 0.2s"
    windowElementPage.style.background = "black"

}

function onDoneBlink() {
    console.log("Stopped Blinking!")
    windowElementPage.style.transition = "background 0.2s"
    windowElementPage.style.background = "white"
}

const BLINK_THRESHHOLD = 0.6
const AI_TICK_RATE = 50; // MS

let lastVideoTime = -1;
let lastTimestamp = performance.now()
let timeElapsedAI = 0.0;
let timeElapsedOverall = 0.0;
let eyeBlinkLeftData = undefined;
let eyeBlinkRightData = undefined;

let wasBlinking = false;
let isBlinking = false;

async function predictWebcam() {
    let results = undefined;

    // just in case for any errors
    try {
        // FIXME: Why here? putting this anywhere else stops the face blendshapes from forming 
        initializeVideoCanvas()
        
        let startTimeMs = performance.now();
        if (lastVideoTime !== windowElementVideo.currentTime) {
            lastVideoTime = windowElementVideo.currentTime;
            results = aiFaceLandmarker.detectForVideo(windowElementVideo, startTimeMs);
        }

        let currentTimestamp = performance.now()
        timeElapsedAI = currentTimestamp - startTimeMs
        timeElapsedOverall = currentTimestamp - lastTimestamp 
        lastTimestamp = currentTimestamp

        // Results is whether a face is present
        isActiveAI = !!results

        // Render Eye Landmarks onto canvas
        if (results?.faceLandmarks) {
            const landmarks = results.faceLandmarks[0]
            drawingUtils.drawConnectors(landmarks, FaceLandmarker.FACE_LANDMARKS_RIGHT_EYE, { color: "#FF3030" });
            drawingUtils.drawConnectors(landmarks, FaceLandmarker.FACE_LANDMARKS_LEFT_EYE, { color: "#30FF30" });
        }

        // Stats
        if (results?.faceBlendshapes?.length) {
            isActiveAI = true;
            let faceData = results.faceBlendshapes[0];
            eyeBlinkLeftData = faceData.categories[9]
            eyeBlinkRightData = faceData.categories[10]

            let leftEyeBlinkPerc = eyeBlinkLeftData.score
            let rightEyeBlinkPerc = eyeBlinkRightData.score

            if (leftEyeBlinkPerc > BLINK_THRESHHOLD && rightEyeBlinkPerc > BLINK_THRESHHOLD) {
                isBlinking = true
            } 

            if (leftEyeBlinkPerc < BLINK_THRESHHOLD || rightEyeBlinkPerc < BLINK_THRESHHOLD) {
                isBlinking = false;
            }

            if (!wasBlinking && isBlinking) {
                onBlink()
            } else if (wasBlinking && !isBlinking) {
                onDoneBlink()
            }

            wasBlinking = isBlinking

        } else {
            isActiveAI = false;
        }

    } catch (e) {
        console.error(e);
        isActiveAI = false
    }

}
function drawDebugMenu(el, { eyeBlinkLeftData, eyeBlinkRightData, timeElapsedAI, timeElapsedOverall, blinkThreshhold, isActiveAI }) {
    let htmlString = "";
    
    const htmlMacro = (title, value, width=0) => (
        `<li class="blend-shapes-item">
        <span class="blend-shapes-label">${title}</span>
        <span class="blend-shapes-value" style="width: calc(${width}% - 100px)">${value}</span>
        </li>`
    )

    htmlString += htmlMacro("Overall Time:",`${(timeElapsedOverall).toFixed(0)}ms`)
    htmlString += htmlMacro("AI Time:",`${(timeElapsedAI).toFixed(0)}ms`)
    htmlString += htmlMacro("Is AI Active?",isActiveAI)
    htmlString += htmlMacro(eyeBlinkLeftData.displayName || eyeBlinkLeftData.categoryName, (+eyeBlinkLeftData.score).toFixed(4), eyeBlinkLeftData.score * 100)
    htmlString += htmlMacro(eyeBlinkRightData.displayName || eyeBlinkRightData.categoryName, (+eyeBlinkRightData.score).toFixed(4), eyeBlinkRightData.score * 100)
    htmlString += htmlMacro("Blink Thold:",`${(blinkThreshhold).toFixed(4)}`)

    el.innerHTML = htmlString;
}


async function loadFaceLandmarker() {
    try {
        const filesetResolver = await FilesetResolver.forVisionTasks("https://cdn.jsdelivr.net/npm/@mediapipe/tasks-vision@0.10.3/wasm");
        const faceLandmarker = await FaceLandmarker.createFromOptions(filesetResolver, {
            baseOptions: {
                modelAssetPath: `https://storage.googleapis.com/mediapipe-models/face_landmarker/face_landmarker/float16/1/face_landmarker.task`,
                delegate: "GPU",
            },
            outputFaceBlendshapes: true,
            runningMode: "VIDEO",
            numFaces: 1
        })

        console.log("Finished Initializing AI.")
        return faceLandmarker;
    } catch(e) {
        // TODO: Handle Error
        console.error("COULD NOT LOAD AI:")
        console.error(e)
        return
    }
}

async function loadWebcamStream() {
    try {
        const stream = await navigator.mediaDevices.getUserMedia({ video: true })

        console.log("Finished loading webcam stream.")
        return stream
    } catch (e) {
        console.error("Cannot access Webcam!:")
        console.error(e)
    }
}

async function main() {
    if (!pageSupportsWebcam()) {
        // TODO: Better handling of no webcam
        alert("This website does not support webcam!")
        return
    }

    let stream;
    [aiFaceLandmarker, stream] = await Promise.all([loadFaceLandmarker(), loadWebcamStream()])

    isActiveAI = true;
    console.log(stream)


    function tickAI() {
        if (stream.active) {
            predictWebcam()
        } else {
            isActiveAI = false
        }

        if (isDebugMode) {
            drawDebugMenu(videoBlendShapes, { eyeBlinkLeftData, eyeBlinkRightData, timeElapsedAI, timeElapsedOverall, blinkThreshhold: BLINK_THRESHHOLD, isActiveAI });
        }
    }

    windowElementVideo.srcObject = stream
    windowElementVideo.addEventListener("loadeddata", () => { 
        tickAI()
        setInterval(tickAI, AI_TICK_RATE) 
    })


    console.log("Finished Initialization")

}


main()