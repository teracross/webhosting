from googleapiclient.discovery import build
from google.oauth2.service_account import Credentials
from googleapiclient.http import MediaIoBaseDownload
import io
import os

CLIENT_SECRETS_FILE = "services.json"
SCOPES = ['https://www.googleapis.com/auth/drive']
API_SERVICE_NAME = 'drive'
API_VERSION = 'v3'
FILE_ID = os.environ['GOOGLE_FILE_ID']
OUTPUT_FORMAT = 'text/html'


credentials = Credentials.from_service_account_file(CLIENT_SECRETS_FILE, scopes=SCOPES)
drive_service = build(API_SERVICE_NAME, API_VERSION, credentials=credentials)

# --- standard Google Drive API file download snippet ----
try: 
  files_request = drive_service.files().export(fileId=FILE_ID,mimeType=OUTPUT_FORMAT)
  # Download the exported content
  fh = io.BytesIO()
  downloader = MediaIoBaseDownload(fh, files_request)
  done = False
  while not done:
    status, done = downloader.next_chunk()
    print(f"Download progress: {int(status.progress() * 100)}%")

    # Save the exported content (e.g., to a file)
    fh.seek(0)
    with open("index.html", "wb") as f: 
      f.write(fh.read())
    print("File exported successfully!")

except Exception as e:
  print(f"An error occurred: {e}")