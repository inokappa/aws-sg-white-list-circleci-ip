source $(pwd)/src/scripts/common.sh

Add() {
  Common

  echo ""
  echo ""
  echo "PARAM_GROUPID = << parameters.group-id >>"
  echo "PARAM_GROUPID = ${PARAM_GROUPID}"
  echo "Allowing CircleCI to access port ${PARAM_PORT} from IP ${IP} to the security group ${PARAM_GROUPID}"

  ${AWS_COMMAND} ec2 authorize-security-group-ingress --group-id "${PARAM_GROUPID}" --ip-permissions \
    $(echo '[{"IpProtocol": "tcp", "FromPort": 443, "ToPort": 443, "IpRanges": [{"CidrIp": "", "Description": "CircleCI"}]}]' \
      | jq -c '.[].IpRanges[].CidrIp="'${IP}/${PARAM_MASK}'"|.[].IpRanges[].Description="'${PARAM_DESC}'"|.[].FromPort='${PARAM_PORT}'|.[].ToPort='${PARAM_PORT}'')
}

ORB_TEST_ENV="bats-core"
if [ "${0#*$ORB_TEST_ENV}" == "$0" ]; then
  Add
fi
