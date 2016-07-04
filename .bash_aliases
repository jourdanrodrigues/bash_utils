# Clear Docker
function restart_docker(){
  docker_containers=$(docker ps -aq)
  docker_volumes=$(docker volume ls -q)

  if [ "$docker_containers" != "" ]; then
    docker rm $docker_containers
    echo "Containers cleaned."
  else echo "No containers."
  fi

  if [ "$docker_volumes" != "" ]; then
    docker volume rm $docker_volumes
    echo "Volumes cleaned."
  else echo "No volumes."
  fi
}

# Git shortcuts
function push_it(){
  if [ "$1" != "" ]; then

    if [ "$1" == "all" ] && [ "$2" != "" ]; then
      echo "Commiting and pushing all changes..."
      git add .
      commit_message=$2
    else
      commit_message=$1
    fi

    git commit -m "$commit_message"

    if [ "$1" == "all" ]; then
      remote="$3"
      branch="$4"
    else
      remote="$2"
      branch="$3"
    fi

    if [ $remote == "" ] && [ $branch == ""]; then
      echo "Trying to push to a tracked remote branch..."
      git push
    elif [ $remote != "" ] && [ $branch != "" ]; then
      echo "Trying to push to remote \"$remote\", branch \"$branch\"..."
      git push $remote $branch
    fi
  else
    echo "Usage: push_it [all] \"commit message\" [remote] [branch]."
  fi
}
