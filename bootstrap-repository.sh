#!/bin/sh

case $1 in
	"user")
		directory="."
		;;
	"project")
		directory="docs"
		;;
	*)
    echo "usage: $0 [user | project]"
		exit 1
		;;
esac

if [ ! -e "$directory" ]; then
	mkdir "$directory"
fi

docker run -v "$PWD":/srv/jekyll jekyll/jekyll:3.8.5 jekyll new --force "$directory"
patch -Np0 "$directory"/Gemfile < Gemfile.patch
docker run -v $PWD/"$directory":/srv/jekyll jekyll/jekyll:3.8.5 bundle update

echo "DIRECTORY=$directory" > .env
echo ".env" >> .gitignore

# patch rejected file
echo "*Gemfile.rej" >> .gitignore

docker-compose up
