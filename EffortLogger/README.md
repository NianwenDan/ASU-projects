# CSE360 EffortLogger Project

## Team W14 Members

- Shivom Khare

- Michael Rejo

- Siddhant Jain

- Nianwen Dan

- Sayyed Qadri


## Running Instructions

In order to let the project running, please read the instruction below carefully!

You will need the following environment installed or downloaded:

- Eclipse
- JavaFX
- Sqlite

### Step 1: unzip the file

Depends on your operaing system, unzip the file from Canvas.

### Step 2: Import the project

Select `File` --> `Import...` --> `Project from Folder or Archive` --> Indicate input source --> `Finish`

### Step 3: Configure JavaFX framework

Please refer [JavaFX documentation](https://openjfx.io/openjfx-docs/) for this step.

### Step 4: Configure Sqlite

Access [Sqlite GitHub Pages](https://github.com/xerial/sqlite-jdbc/releases), then download the latest version of `.jar` file.

Go to the eclipse, and right click the project. Select `Build Path` --> `Configure Build Path...`

Under the `Libraries` Tab, remove everything expect `JavaFx` and `JRE System Library`, under the `Modulepath` section.

Click `Modulepath` --> `Add External JARs` --> Choose your Sqlite `.jar` file downloaded from GitHub. --> `Open`

### Step 5: Run the project

Your project should be able to run now.

## Project Structure

```
.
├── README.md
├── build.fxbuild
└── src
    ├── application
    │   ├── Main.java
    │   └── application.css
    ├── encryption
    │   └── SHA256.java
    ├── main
    │   └── Main.java
    ├── scenes
    │   └── Scenes.java
    └── sqlite
        ├── SQLite.java
        └── SQLiteMain.java
```

The program entry file is under `src/application/Main.java`, find that file and run the program. Notes that an `*.db` file will be automatically generated.

If you want to re-install the program, please remove the `*.db` file.