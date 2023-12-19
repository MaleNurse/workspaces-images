<h1 align="center">
  <br>
  <img width="240" src="https://raw.githubusercontent.com/wiki/doctorfree/kasm-registry/logo.png">
  <br>
  Record Technologies Kasm Workspace Images
  <br>
</h1>

This repository contains several examples of desktop and application Kasm
Workspaces images. Administrators may leverage these images directly or use
them as a starting point for their own custom images. Each of these images
is based off one of the
[**Workspaces Core Images**](https://github.com/kasmtech/workspaces-core-images?utm_campaign=Github&utm_source=github)
which contain the necessary wiring to work within the Kasm Workspaces platform.

For more information about building custom images please review the
[**How To Guide**](https://kasmweb.com/docs/latest/how_to/building_images.html?utm_campaign=Github&utm_source=github)

The Kasm team publishes applications and desktop images for use inside the platform.
More information, including source can be found in the
[**Default Images List**](https://kasmweb.com/docs/latest/guide/custom_images.html?utm_campaign=Github&utm_source=github)

## Table of Contents

- [Repository Structure](#repository-structure)
- [Manual Deployment](#manual-deployment)
  - [Manual Execution](#manual-execution)
- [About Workspaces](#about-workspaces)
- [Record Technologies Workspace Registry](#record-technologies-workspace-registry)
  - [Workspace features](#workspace-features)
  - [Registry deployment](#registry-deployment)
- [Live Demo](#live-demo)

## Repository Structure

The top-level directory of this repository contains the Dockerfiles used to
build the Kasm workspace images deployed to the
[Record Technologies Kasm Workspace Registry](https://doctorfree.github.io/kasm-registry).
By convention, these Dockerfiles have a `.Dockerfile` filename suffix.

The subdirectory `kasmtech` contains the Dockerfiles used by the `kasmtech` project
from which this repository was forked. By convention, these Dockerfiles have a
`dockerfile-kasm` filename prefix.

The subdirectory `dev` contains Dockerfiles in development but not yet deployed
to the Record Technologies workspace registry.

The `bin` directory contains convenience scripts used to build and push the
workspace images.

The `src` directory contains files, scripts, archives, configuration, and
data used by each image build.

## Manual Deployment

Use `docker` to build the provided images. For example, to build the
`doctorwhen/kasm:neovim` image for the `Neovim` workspace:

```bash
sudo docker build -t doctorwhen/kasm:neovim -f kasm-neovim.Dockerfile .
```

Convenience scripts exist for some image builds. For example, to build
the `doctorwhen/kasm:neovim` image for the `Neovim` workspace using the
provided convenience script:

```bash
bin/build-neovim
```

For some image builds it is necessary to use the convenience script as
this script modifies some files in the build to add a Github API key if
one is present in the environment.

### Manual Execution

While these image are primarily built to run inside the Workspaces platform,
they can also be executed manually. Please note that certain functionality,
such as audio, uploads, downloads, and microphone pass-through are only
available within the Kasm platform.

```
sudo docker run --rm  -it --shm-size=512m -p 6901:6901 -e VNC_PW=password doctorwhen/kasm:neovim
```

The container is now accessible via a browser : `https://<IP>:6901`

- **User** : `kasm_user`
- **Password**: `password`

**NOTE:** Several of the Record Technologies Kasm workspaces perform extensive
post-installation configuration. For this reason they are not well suited for
use with `docker run ...` since each time they are run in this manner they will
perform the time consuming initialization. The recommended use for these images
is as Kasm Workspaces streamed containers with a persistent profile configured.

## About Workspaces

Kasm Workspaces is a docker container streaming platform that enables you to
deliver browser-based access to desktops, applications, and web services.
Kasm uses a modern DevOps approach for programmatic delivery of services via
Containerized Desktop Infrastructure (CDI) technology to create on-demand,
disposable, docker containers that are accessible via web browser.

The rendering of the graphical-based containers is powered by the open-source
project
[**KasmVNC**](https://github.com/kasmtech/KasmVNC?utm_campaign=Github&utm_source=github)

![Screenshot][Kasm_Workflow]

Kasm Workspaces was developed to meet the most demanding secure collaboration
requirements that is highly scalable, customizable, and easy to maintain.
Most importantly, Kasm provides a solution, rather than a service, so it is
infinitely customizable to your unique requirements and includes a developer
API so that it can be integrated with, rather than replace, your existing
applications and workflows. Kasm can be deployed in the cloud
(Public or Private), on-premise (Including Air-Gapped Networks), or in a
hybrid configuration.

## Record Technologies Workspace Registry

![registry](https://raw.githubusercontent.com/wiki/doctorfree/kasm-registry/registry.png)

The [Record Technologies](https://doctorfree.github.io/kasm-registry) workspace
registry serves as the distribution mechanism for Kasm workspaces
generated from [Doctorfree Open Source Projects](https://github.com/doctorfree).

Currently available workspaces in this registry include:

* `AppImage`: Customized Ubuntu 22.04 desktop with [AppImage Launcher](https://github.com/TheAssassin/AppImageLauncher)
* [Asciiville](https://github.com/doctorfree/Asciiville#readme): Ascii art, utilities, games, more
* `CloudStorage`: Utilizes [rclone](https://github.com/rclone/rclone), a command-line program to manage files on cloud storage
* `Deluxe`: Asciiville, Neovim, Spiderfoot, Wing and more all in one workspace
* [LM Studio](https://github.com/lmstudio-ai): Customized Ubuntu 22.04 desktop with `LM Studio`
* [Neovim](https://github.com/doctorfree/nvim-lazyman#readme): Neovim, neovide, lazyman, much more
* [Open-Source Intelligence](https://en.wikipedia.org/wiki/Open-source_intelligence): Reconnaissance tool, forensics, link analyzer, ...
* [Project Jupyter](https://en.wikipedia.org/wiki/Project_Jupyter): Jupyter notebooks
* [Spiderfoot](https://github.com/smicallef/spiderfoot): A reconnaissance tool that automatically queries public data sources to gather intelligence
* [Ubuntu desktops](https://en.wikipedia.org/wiki/Ubuntu): Customized Ubuntu Focal and Jammy desktops
* [Wing cloud programming language](https://www.winglang.io): Wing programming language, examples, and editors
* `WingPlus`: The Wing workspace with the Neovim hyper-extensible text editor
* More to come ...

### Workspace features

Record Technologies workspaces all include customized desktops with several
additional productivity and development packages preconfigured for ease of use.
For example, the Wing workspaces include Visual Studio Code with the Wing
extension; the Neovim workspaces include Neovide and Lazyman - the Neovim
Configuration Manager, several workspaces include the
[Ranger File Manager](https://github.com/ranger/ranger)
with customized launch configurations and the
[Btop++ system monitor](https://github.com/aristocratos/btop)
with customized configuration and theme.

In most Record Technologies workspaces the
[Kitty terminal emulator](https://sw.kovidgoyal.net/kitty)
is installed along with the `JetBrains Mono`
[Nerd Font](https://github.com/ryanoasis/nerd-fonts).
Kitty is preconfigured and Kitty sessions are tailored for each
use case.

Where appropriate Record Technologies workspaces perform a `postinstall`
which installs and configures many additional utilities in the Kasm user's
home directory. When used in conjunction with Kasm persistent profiles
this feature enables a rich persistent user runtime environment across
workspace sessions.

### Registry deployment

All Record Technologies workspaces are designed for deployment using
[Kasm Workspaces](https://kasmweb.com). The Docker images can be deployed
directly with Docker but they will not provide persistent user profiles
and thus will not be as usable, requiring initialization on every start.
The use of Kasm Workspaces for deployment is strongly encouraged.

To deploy using Kasm Workspaces, add the Record Technologies registry to
your Kasm deployment by visiting the
[Record Technologies workspace registry](https://doctorfree.github.io/kasm-registry)
and clicking on the `Workspace Registry Link`. This will copy
`https://doctorfree.github.io/kasm-registry/` to your clipboard.

Once you have the Workspace Registry Link for Record Technologies, in Kasm
as an administrator click on `Workspaces` -> `Registry` -> `Registries`.
Click `Add new` and enter the Record Technologies registry link copied above.
Click `ADD REGISTRY` and you should now see the Record Technologies workspaces
in Kasm.

After adding a 3rd party workspace registry to Kasm, clicking on `Workspaces` ->
`Registry` should now show the new registry under `Available Workspaces`.
Clicking on `Record Technologies` will filter the available workspaces and
display only those workspaces available from Record Technologies.

Click on any of the Record Technologies workspaces and then click `Install`
to install that workspace. Once installed go to `Workspaces` -> `Workspaces`
and click the right arrow button on the right hand side of the newly installed
workspace then click the pencil icon to edit the workspace. Adjust any of
the settings you like but most importantly scroll down to the
`Persistent Profile Path` and add a path to save changes users make to their
workspace. I use the following setting for a persistent profile:

```
/u/kasm_profiles/{image_id}/{user_id}
```

Where the `/u/kasm_profiles/` folder has been created on the Kasm host. Note that
this folder can grow quite large depending on how many workspaces are configured
to use it and how many users are active. I place this folder along with any
volume mappings and the Docker library folders on a large second drive using XFS.

## Live Demo
A self-guided on-demand demo is available at
[**kasmweb.com**](https://www.kasmweb.com/demo.html?utm_campaign=Github&utm_source=github)

[logo]: https://cdn2.hubspot.net/hubfs/5856039/dockerhub/kasm_logo.png "Kasm Logo"
[Kasm_Workflow]: https://cdn2.hubspot.net/hubfs/5856039/dockerhub/kasm_workflow_960.gif "Kasm Workflow"
