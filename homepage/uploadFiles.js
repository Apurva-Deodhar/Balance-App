const admin = require("firebase-admin");
const path = require("path");
const fs = require("fs");

// Initialize Firebase Admin with your service account
const serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  storageBucket: "gs://balance-131e6" // Replace with your bucket name
});

const bucket = admin.storage().bucket();
const assetsDir = path.join(__dirname, "assets"); // Path to your assets folder

// Function to upload files
async function uploadFiles() {
  try {
    // Read all files in /assets
    const files = fs.readdirSync(assetsDir);

    for (const file of files) {
      const filePath = path.join(assetsDir, file);
      const destination = `users/${userId}/${file.name}`; // Firebase Storage path

      // Upload file
      await bucket.upload(filePath, {
        destination,
        public: true, // Makes file publicly accessible (optional)
      });

      console.log(`✅ Uploaded: ${file}`);
    }

    console.log("🎉 All files uploaded!");
  } catch (error) {
    console.error("❌ Error:", error);
  }
}

// Run the upload
uploadFiles();