#!/usr/bin/env zsh

available_arguments="
\tupdate: Pull Docker image from the Artifact Registry
\tdbt <run, test, --select, etc>: Runs dbt with the provided dbt sub-command\n
To learn more about dbt, do \"./dbt_docker.sh dbt\" in your Terminal."

help="Argument '$1' is invalid.\n\n$available_arguments"

target_image=eda1:latest

if [ $# -eq 0 ]; then
  printf "The ./dbt_docker.sh script requires a minimum of 1 argument.\n\nAvailable arguments: $available_arguments\n"
elif [[ "$1" == "dbt" && $# -gt 1 ]]; then
  # User wants to do something with dbt and provided argument or sub-command, so let's run it.

  docker build -t $target_image . && \

  docker run --rm \
  --tty \
  --volume "$HOME"/.config/gcloud/:/"$HOME"/.config/gcloud \
  --env GOOGLE_CLOUD_PROJECT="henrytxz" \
  --env YOUR_DBT_DEV_DATASET="$YOUR_DBT_DEV_DATASET" \
  --env GOOGLE_APPLICATION_CREDENTIALS=/"$HOME"/.config/gcloud/application_default_credentials.json \
  --publish 8080:8080 \
  $target_image \
  "$@" && sleep 2
elif [ "$1" == "dbt" ] && [ $# -eq 1 ]; then
  # User wants to do something with dbt but didn't provide an argument nor sub-command.
  # Let's show the dbt man page.
  docker run --rm $target_image dbt
else
  # User did something wrong, display help message.
  printf "%s" "$help"
fi
