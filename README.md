# Henson Field App - GitHub Build Repo

This repo contains a starter Flutter app (Field Service) and a GitHub Actions workflow
that builds a Windows `.exe` automatically.

## What I will do for you
- You create a **new empty GitHub repo** named `henson-field-app` under your account.
- You unzip and upload the files from this package (or push via git).
- GitHub Actions will run automatically and produce a downloadable `.exe` artifact.

## Very simple steps (web method - no git required)
1. On GitHub, create a new repository named `henson-field-app` under account **HensonRepairLLC**.
2. Download this ZIP and unzip it locally.
3. In the GitHub repo page click **Add file → Upload files**, then drag-and-drop *all files and folders* from the unzipped folder (do NOT upload the ZIP itself). Commit the upload.
4. On the GitHub repo page go to the **Actions** tab. You should see the workflow `Build Windows EXE`. Click it, then click **Run workflow** (or wait — it will often start automatically).
5. When the workflow completes, click the latest workflow run and download the artifact named `henson-field-app-windows-exe` from the **Artifacts** section.
6. Unzip the artifact — inside `build/windows/runner/Release/` you'll find the `.exe` and supporting files. Run the `.exe` on your Windows PC.

## Notes & runtime configuration
- Open `lib/main.dart` and replace `YOUR_SUPABASE_URL` and `YOUR_SUPABASE_ANON_KEY` with your Supabase values if you plan to connect to the live backend.
- If you don't provide Supabase values the app will still run; features that depend on the backend will fail gracefully.
- Building the Windows release requires no special secrets for this starter app.

## If you want me to automate uploads:
If you prefer, I can instead provide a step-by-step guide to push the code via git (faster for future updates). Tell me if you'd like that.
