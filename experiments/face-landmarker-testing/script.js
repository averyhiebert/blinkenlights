// TOOD: 404's a resource, why?
import { FaceLandmarker, FilesetResolver, DrawingUtils } from "https://cdn.jsdelivr.net/npm/@mediapipe/tasks-vision@0.10.3";

let isDebugMode = true;
let isActiveAI = false;
const videoWidth = 480;

const windowElementDebug = document.getElementById("debug")
const windowElementVideo = document.getElementById("webcam");
const windowElementCanvas = document.getElementById("output_canvas");
const videoBlendShapes = document.getElementById("video-blend-shapes");

let aiFaceLandmarker = null;
const canvasCtx = windowElementCanvas.getContext("2d");

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

let lastVideoTime = -1;
let results = undefined;
const drawingUtils = new DrawingUtils(canvasCtx);
async function predictWebcam() {
    const radio = windowElementVideo.videoHeight / windowElementVideo.videoWidth;
    windowElementVideo.style.width = videoWidth + "px";
    windowElementVideo.style.height = videoWidth * radio + "px";
    windowElementCanvas.style.width = videoWidth + "px";
    windowElementCanvas.style.height = videoWidth * radio + "px";
    windowElementCanvas.width = windowElementVideo.videoWidth;
    windowElementCanvas.height = windowElementVideo.videoHeight;
    // Now let's start detecting the stream.
    let startTimeMs = performance.now();
    if (lastVideoTime !== windowElementVideo.currentTime) {
        lastVideoTime = windowElementVideo.currentTime;
        results = aiFaceLandmarker.detectForVideo(windowElementVideo, startTimeMs);
    }

    if (results.faceLandmarks) {
        for (const landmarks of results.faceLandmarks) {
            drawingUtils.drawConnectors(landmarks, FaceLandmarker.FACE_LANDMARKS_RIGHT_EYE, { color: "#FF3030" });
            drawingUtils.drawConnectors(landmarks, FaceLandmarker.FACE_LANDMARKS_LEFT_EYE, { color: "#30FF30" });
        }
    }
    drawBlendShapes(videoBlendShapes, results.faceBlendshapes);

    // Call this function again to keep predicting when the browser is ready.
    window.requestAnimationFrame(predictWebcam);
}
function drawBlendShapes(el, blendShapes) {
    if (!blendShapes.length) {
        return;
    }
    // console.log(blendShapes[0]);
    let htmlMaker = "";
    let eyeBlinkLeftData = blendShapes[0].categories[9]
    let eyeBlinkRightData = blendShapes[0].categories[10]
    
    function debugHTML() {
        htmlMaker = "";

        htmlMaker += `<li class="blend-shapes-item">
        <span class="blend-shapes-label">AI Active</span>
        <span class="blend-shapes-value"  style="width: calc(${isActiveAI ? 100 : 0}% - 120px)"">${isActiveAI}</span>
      </li>`

        const htmlMacro = (shape) => (
            `<li class="blend-shapes-item">
        <span class="blend-shapes-label">${shape.displayName || shape.categoryName}</span>
        <span class="blend-shapes-value" style="width: calc(${+shape.score * 100}% - 120px)">${(+shape.score).toFixed(4)}</span>
      </li>`
        )


        htmlMaker += htmlMacro(eyeBlinkLeftData)
        htmlMaker += htmlMacro(eyeBlinkRightData)

        return htmlMaker

    }

    el.innerHTML = debugHTML()
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

    windowElementVideo.srcObject = stream
    windowElementVideo.addEventListener("loadeddata", predictWebcam)

    console.log("Finished Initialization")

}


main()