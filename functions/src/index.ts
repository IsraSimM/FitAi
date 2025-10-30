import * as functions from "firebase-functions";
import axios from "axios";

// onCall recibe (request, context). Los datos vienen en request.data
export const verifyRecaptcha = functions.https.onCall(async (request, _context) => {
  const token = request.data?.token as string | undefined;
  if (!token) {
    throw new functions.https.HttpsError("invalid-argument", "Missing token");
  }

  const secret = functions.config().recaptcha?.secret;
  if (!secret) {
    throw new functions.https.HttpsError("failed-precondition", "Missing recaptcha secret");
  }

  try {
    const resp = await axios.post(
      "https://www.google.com/recaptcha/api/siteverify",
      new URLSearchParams({ secret, response: token }).toString(),
      { headers: { "Content-Type": "application/x-www-form-urlencoded" } }
    );

    const result = resp.data; // { success, challenge_ts, hostname, ... }
    if (!result?.success) {
      // Opcional: console.error(result["error-codes"]);
      throw new functions.https.HttpsError("permission-denied", "reCAPTCHA validation failed");
    }

    return { ok: true, raw: result };
  } catch (e) {
    throw new functions.https.HttpsError("internal", "Verification error");
  }
});
