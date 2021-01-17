AWS_COMMAND="aws"
if [ -n "${AWS_ENDPOINT}" ];then
  AWS_COMMAND="aws --endpoint ${AWS_ENDPOINT}"
fi

Common() {
  LATEST_IP=$(wget -qO- http://checkip.amazonaws.com)
  IP="${IP-$LATEST_IP}"
  if [ -z "${IP}" ]; then
    echo "Could not find your public IP"
    exit 1
  fi

  if [ -z "${PARAM_GROUPID}" ]; then
    GROUPID=$(${AWS_COMMAND} ec2 describe-security-groups \
      --query 'SecurityGroups[].[Tags[?Key==`${PARAM_TAG_KEY}`] | [0].Value, GroupId]' \
      --output text | grep ${PARAM_TAG_VALUE} | awk '{print $2}')
    [[ -n "${GROUPID}" ]] || (echo "Could not determine Security Group ID" && exit 0);
    PARAM_GROUPID=${GROUPID}
  fi
}

ORB_TEST_ENV="bats-core"
if [ "${0#*$ORB_TEST_ENV}" == "$0" ]; then
  Common
fi
