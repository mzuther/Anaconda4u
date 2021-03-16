# Anaconda4u

*Build your own Anaconda container easily.*

## Motivation

I have a few issues with the Anaconda distribution and its official
Docker images.  So I built what perceive to be an improved image and
want to share it here.  The image should be very easy to extend and
adapt to your needs.

### The "root" of the problem

Currently, Anaconda's Docker images only have a root user.  I don't
even want to start how bad this is.  Even if you're fine with the
implications, as soon as you write files within the container and want
to edit them on the host system, you'll be in trouble.

**Anaconda4u** creates a non-root user with a dedicated home
directory.

### Package managers

I have used at least a dozen package managers over the years.  After a
while, most of them started misbehaving: think dependency hell,
unclean removals, etc.

**Anaconda4u** makes it easy to re-install everything from scratch.
This should also be relatively fast, as the base image remains
untouched and you can use `mamba` instead of `conda` (a.k.a. The
Snail).

### Communication

**Anaconda4u** "publishes" the container's ports to the host and uses
a self-generated TLS certificate for encryption.  It comes with a
shared folder (sub-folder `Documents`) and I created a few symlinks to
make JupyterLab's settings persistent.

### Better defaults

**Anaconda4u** comes with a few defaults that you can either keep or
customise.  A few (in the directory `include`) will be "burned" to the
image for security reasons.

Terminal sessions will run in Bash (with a customised `.bashrc`) and I
have included the console file manager `ranger` for ease of use.

## Contributors

- [Martin Zuther][]: maintainer

## Code of conduct

Please read the [code of conduct][COC] before asking for help, filing
bug reports or contributing to this project.  Thanks!

## License

Copyright (c) 2010-2020 [Martin Zuther][]

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

Thank you for using free software!


[Anaconda]:       https://www.anaconda.com/

[COC]:            CODE_OF_CONDUCT.md
[Martin Zuther]:  http://www.mzuther.de/
[release]:        https://github.com/mzuther/anaconda4u/releases
