OpenVAS 9 container building stages.

1. Prepare jessie:8.10 image:
mkdir -p images/jessie
debootstrap jessie images/jessie
tar -C images/jessie -c -f images/jessie.tar .
docker import images/jessie.tar jessie:8.10

2. Start building:
nohup docker build --no-cache -f builds/Dockerfile -t openvas9:initial_release builds/ 1>builds/build_details 2>&1 &

3. Run container:
docker run -d --net=host --hostname=openvas9 openvas9:initial_release

4. Start all services inside container:
docker exec -ti <container-id> /bin/bash
service redis-server start
/openvas_commander.sh --start-all

