const ort = await import("../ort/ort.all.min.mjs");
const modelPath = "../models/lite_model.onnx";
let session;

async function initModel() {
  session = await ort.InferenceSession.create(modelPath);
}

async function extractFeatures(url) {
  const { hostname, pathname, search } = new URL(url);

  const count = (str, char) =>
    (str.match(new RegExp(`\\${char}`, "g")) || []).length;
  const isSuspiciousTLD = (tld) =>
    ["tk", "ml", "ga", "cf", "gq", "xyz", "top"].includes(tld);
  const isShorteningService = (host) =>
    [
      "bit.ly",
      "tinyurl.com",
      "goo.gl",
      "t.co",
      "ow.ly",
      "is.gd",
      "buff.ly",
    ].includes(host);
  const extractWords = (str) => str.split(/[^a-zA-Z0-9]/).filter(Boolean);
  const tld = hostname.split(".").pop();
  const hostParts = hostname.split(".");
  const pathWords = extractWords(pathname);
  const allWords = extractWords(url);
  const longest = (arr) =>
    arr.reduce((max, cur) => Math.max(max, cur.length), 0);
  const shortest = (arr) =>
    arr.length === 0
      ? 0
      : arr.reduce((min, cur) => Math.min(min, cur.length), Infinity);
  const totalLength = (arr) => arr.reduce((sum, cur) => sum + cur.length, 0);

  const features = [
    count(url, "?"),
    count(hostname, "www"),
    hostname.replace(/[^0-9]/g, "").length / hostname.length,
    /login|confirm|secure|account|update/i.test(url) ? 1 : 0,
    /paypal|amazon|apple|bank|login/i.test(hostname) ? 1 : 0,
    isSuspiciousTLD(tld) ? 1 : 0,
    isShorteningService(hostname) ? 1 : 0,
    shortest(pathWords),
    count(url, ":"),
    totalLength(allWords),
    url.includes("http") ? 1 : 0,
    count(url, "="),
    longest(pathWords),
    count(url, "-"),
    longest(allWords),
  ];

  return new Float32Array(features);
}

async function runInference(url) {
  await initModel();

  const features = await extractFeatures(url);
  const tensor = new ort.Tensor("float32", features, [1, features.length]);
  const output = await session.run({ float_input: tensor });
  const result = output[Object.keys(output)[0]].data[0];
  return result;
}

window.addEventListener("message", async (event) => {
  if (event.data?.type === "sandboxCheck") {
    window.parent.postMessage({ type: "sandboxReady" }, "*");
  }
  if (event.data?.type === "runML") {
    try {
      const score = await runInference(event.data?.url);
      window.parent.postMessage({ type: "mlResult", result: score }, "*");
    } catch (e) {
      console.error("ML Inference failed", e);
      window.parent.postMessage(
        { type: "mlResult", result: null, error: true },
        "*"
      );
    }
  }
});
