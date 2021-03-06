# Anaconda4u

_Build your own Anaconda container easily._

## Motivation

I have a few issues with the Anaconda distribution and its official
Docker images. So I built what perceive to be an improved image and
want to share it here. The image should be very easy to extend and
adapt to your needs.

### The "root" of the problem

Currently, Anaconda's Docker images only have a root user. I don't
even want to start how bad this is. Even if you're fine with the
implications, as soon as you write files within the container and want
to edit them on the host system, you are in trouble.

**Anaconda4u** creates a non-root user with a dedicated home
directory.

### Package managers

I have used at least a dozen package managers over the years. After a
while, most of them started misbehaving: dependency hell, unclean
removals, and so on.

**Anaconda4u** makes it easy to re-install everything from scratch.
This should also be relatively fast, as the base image remains
untouched and you can use `mamba` instead of `conda` (a.k.a. The
Snail).

### Reproducibility

I regularly re-build the work image from scratch by executing
`./build.sh --no-cache`. Work images are labelled with _two_ tags:
`anaconda4u.work:latest` and `anaconda4u.work:2021-04-09` (using the
current date).

So when an update introduces a bug or you want to re-visit an old
project, all you have to do is open your editor, change a single line
and get back to work! Simply open `./anaconda4u.sh` and change
`use_image` to the working image of your choice.

### Communication

**Anaconda4u** "publishes" a container's JupyterLab port to the host
and uses a self-generated TLS certificate for encryption. It comes
with a shared folder (sub-folder `Documents/`) and I created a few
symlinks to make JupyterLab's settings persistent and editable from
the outside.

In addition, your `DISPLAY` environment variable is mirrored in the
container. Thus, you can run (most) GUI applications in the container
and their UI will open in your current X session.

### Better defaults

**Anaconda4u** comes with a few defaults that you can either keep or
customise. A few (in the folder `include/`) will be "burned" to the
image for security reasons.

Terminal sessions will run in Bash (with a customised `.bashrc`) and I
have included the console file manager `ranger` for ease of use.

## Instructions

1. install the dependencies (Debian): `apt-get install bash curl docker.io openssl rsync xdg-utils`
1. customise the settings in folder `data/` (optional)
1. run `./build.sh` to create base, intermediate and work images
1. use `./anaconda4u.sh` run a new container and execute commands:
   `./anaconda4u.sh` logs you into a Bash shell and `./anaconda4u.sh ranger` starts a file manager in your home directory
1. run `./jupyter-lab.sh` to run a new container, start JupyterLab and
   open your favourite browser (via `xdg-open`)

The scripts `./build.sh` and `./build-dev.sh` accept arguments that
are passed on to `docker-build` of the intermediate and work images.
So in order to build these images from scratch, run `./build.sh --no-cache`.

## Updates

When official Anaconda images are updated, run `./build.sh` to create
new base, intermediate and work images. Also, any new settings files
I have added will be copied to your system.

Existing settings files will _not_ be overwritten. Please run
`./build-dev.sh` to **overwrite customised settings** in the image
with those in the `data/` folder.

I recommend that you can create a Git branch with your settings and
then merge updates to this repository into it. This way, your
settings should be quite safe from being changed by accident.

## Contributors

- [Martin Zuther][]: maintainer

## Code of conduct

Please read the [code of conduct][coc] before asking for help, filing
bug reports or contributing to this project. Thanks!

## License

Copyright (c) 2010-2020 [Martin Zuther][]

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.

Thank you for using free software!

[anaconda]: https://www.anaconda.com/
[coc]: CODE_OF_CONDUCT.md
[martin zuther]: http://www.mzuther.de/
[release]: https://github.com/mzuther/anaconda4u/releases
