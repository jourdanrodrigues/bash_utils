# Clear Docker
function clear_docker(){
  docker_containers=$(docker ps -aq)
  docker_volumes=$(docker volume ls -q)
  docker_networks=$(docker network ls | awk 'NR > 1 { print $1 " " $2 }' | grep -v 'bridge\|host\|none' | awk '{print $1}')
  docker_images=$(docker images -q)

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

  if [ "$docker_networks" != "" ]; then
    docker network rm $docker_networks
    echo "Networks cleaned."
  else echo "No networks."
  fi

  if [ "$docker_images" != "" ]; then
    docker rmi -f $docker_images
    echo "Images cleaned."
  else echo "No images."
  fi
}

# Git shortcuts
function push_it(){

  usage="Usage: push_it [all] \"commit message\" [remote] [branch]."

  if [ "$1" == "" ]; then
    echo $usage
    return
  fi

  if [ "$1" == "all" ]; then
    if [ "$2" == "" ]; then
      echo "Commit message not provided."
      return
    fi

    commit_echo_message="Commiting all changes..."
    commit_message=$2
    all=1
    remote=$3
    branch=$4

  else
    commit_echo_message="Commiting changes in the index..."
    commit_message=$1
    all=0
    remote=$2
    branch=$3

  fi

  if [ "$remote" == "" ] && [ "$branch" == ""]; then
    echo $commit_echo_message
    if [ $all -eq 1 ]; then
      git add .
    fi
    git commit -m "$commit_message"
    echo "Trying to push to a tracked remote branch..."
    git push

  elif [ "$remote" != "" ] && [ "$branch" != "" ]; then
    echo $commit_echo_message
    git commit -m "$commit_message"
    echo "Trying to push to remote \"$remote\", branch \"$branch\"..."
    git push $remote $branch

  else
    echo $usage
  fi
}
