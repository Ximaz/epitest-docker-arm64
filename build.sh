#!/bin/zsh

DEFAULT_TAG="latest"

function usage {
	local NAME="$(basename $0)"

	echo "${NAME} - epitest-docker build script"
	echo "\tBuild the epitest-docker image from sources"
	echo ""
	echo "Usage"
	echo "\t${NAME} [-n] [-t TAG]"
	echo "\t${NAME} -c"
	echo ""
	echo "\t-t TAG\ttag to apply to the docker image"
	echo "\t      \tdefault: ${DEFAULT_TAG}"
	echo "\t-n    \tpass --no-cache to docker build"
}

function read_opts {
	local TAG="${DEFAULT_TAG}"
	local DOCKER_OPTS=""

	while [[ $# -gt 0 ]]; do
		key="${1}"

		case "${key}" in
			-h|--help)
			usage
			exit 0
			;;
			-t|--tag)
			TAG="${2}"
			shift
			;;
			-n)
			DOCKER_OPTS="--no-cache ${DOCKER_OPTS}"
			;;
			*)
			echo "Unsupported argument $1"
			exit 1
			;;
		esac

		shift
	done
	opts=("${TAG}" "${DOCKER_OPTS}")
}

function build_image {
	local TAG="${1}"
	local DOCKER_OPTS="${2}"

	docker build $DOCKER_OPTS --pull --tag "ximaz/epitest-docker-aarch64:${TAG}" .

	if [[ "${?}" -ne 0 ]]; then
		echo "Failed to build the docker image."
		exit 1
	fi
}

function main {
	read_opts
	build_image "${opts[1]}" "${opts[2]}"
}

main
