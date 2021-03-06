# docker-rust-persistent

Creates a Docker image that contains stable or nightly channels of the [Rust systems programming language](https://www.rust-lang.org).

The special goal of the image is to provide the Rust toolchain in dockerized form and at the same time `preserve user rights` of files. This means that files that are created from within the container have the same `UID` and `GID` as the host-user that spawned the container instance.

If you use the supplied `run.sh` file, `$RUSTUP_HOME` and `$CARGO_HOME` are kept in [named volumes](https://docs.docker.com/engine/admin/volumes/volumes/), so that cargo and rustup downloads and objects are cached between multiple container runs.

**Tested for Linux hosts only.**

## Usage

1. **Optional** Build the container image with `make`. By default, images will be pulled from [Dockerhub](https://hub.docker.com/r/andrerichter/docker-rust-persistent/).
2. Install an alias for `run.sh` for easy invocation of the container.
    1. Stable: `echo "alias rust='~/repos/docker-rust-persistent/run.sh'" >> ~/.bash_aliases`
	2. Nightly: `echo "alias rust-nightly='~/repos/docker-rust-persistent/run.sh -c=nightly'" >> ~/.bash_aliases`
3. Navigate to the folder containing your rust project and start the container from there.
4. Use the container shell to call `cargo` or `rustc`.

## Demo

![Image of Usage](https://raw.githubusercontent.com/andre-richter/docker-rust-persistent/master/demo/docker-rust-persistent.gif)

## License

See the LICENSE file.
