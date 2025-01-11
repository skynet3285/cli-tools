#!/bin/bash

set -e

used_images=$(docker ps -a --format "{{.Image}}" | xargs -I {} docker images --no-trunc --filter "reference={}" -q | awk -F ':' '{print $2}' | cut -c1-12)
all_images=$(docker images -q)


# Filter out the images that are not in use by containers
images_to_delete=()
for img in $all_images; do
  if ! echo "$used_images" | grep -q -w "$img"; then
    images_to_delete+=($img)
  fi
done

if [ ${#images_to_delete[@]} -eq 0 ]; then
  echo "No images to delete. Using images are excluded."
  exit 0
fi

echo "Warning: All images that are not being used by containers will be deleted!"
echo "Images to be deleted: ${images_to_delete[@]}"
read -p "Are you sure you want to delete these images? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
  echo "Image deletion canceled."
  exit 0
fi

for img in "${images_to_delete[@]}"; do
  docker rmi "$img"
done

echo "Image deletion completed."