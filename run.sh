#! /bin/bash
docker build -t kityminder-meteor ~/install-kityminder-meteor
docker run -p 8899:8899 kityminder-meteor:last
