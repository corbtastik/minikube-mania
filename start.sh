#!/bin/bash
# start options
profile=${profile:-dev}
driver=${driver:-vmware}
cpus=${cpus:-2}
memory=${memory:-8192}
disk=${disk:-32}
crt=${crt:-'cri-o'}
# parse options
while [ $# -gt 0 ]; do
   if [[ $1 == *"--"* ]]; then
        param="${1/--/}"
        declare $param="$2"
   fi
  shift
done
# startup banner
echo "== minikube starting ============"
echo "   profile: ${profile}           "
echo "   driver:  ${driver}            "
echo "   cpus:    ${cpus}              "
echo "   memory:  ${memory}            "
echo "   disk:    ${disk}g             "
echo "   crt:     ${crt}               "
echo "================================="
# start
minikube start --vm=true \
  --profile=${profile} \
  --driver=${driver} \
  --container-runtime=${crt} \
  --cpus=${cpus} \
  --memory=${memory} \
  --disk-size=${disk}g
