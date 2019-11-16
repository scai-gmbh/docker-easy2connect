# export e2cid=12-34-56-78
# export installcode=asdfghjklqwertzu1234
echo "Make sure nothing is running"
docker-compose down
echo "Remove eventually existing image"
docker rmi easy2connect_easy2connectbox:latest
docker-compose rm
echo "Building..."
docker-compose build
echo "To start run: docker-compose up -d"
