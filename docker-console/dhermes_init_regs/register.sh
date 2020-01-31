#! /bin/sh
IPPORT_WWES_CLUSTER="$(gcloud compute instances list | grep 'es-ww' | head -n 1 | awk '{print $4}'):9200"
IPPORT_DHERMES_CLUSTER="$(gcloud compute instances list | grep 'hermes' | head -n 1 | awk '{print $4}'):9200"
CODE_NAME=""
TOKEN=""

#-- the url with default recommendation API
#   i.e. http://apir.venraas.tw/cupid/api/goods/rank
URL_CUPID_API=""

SCRIPT_DIR="$(cd $(dirname $0) && pwd)"

function print_usage() {
	name=`basename "$0"`
	echo 
	echo "NAME"
	echo "	${name} - register init channels to an new company"
	echo "SYNOPSIS"
	echo "	${name} -t=TOKEN -cn=CODE_NAME -uca=URL_CUPID_API"
	exit 0	
}

#-- option parser
for i in "$@"
do
	case $i in
		-t=*|--token=*)
			TOKEN="${i#*=}"
			#-- validation
			cnt=$(curl -s "http://${IPPORT_WWES_CLUSTER}/_count?q=companies.token:${TOKEN}" | python -c "import sys, json; print json.load(sys.stdin)['count']")
			if [ ${cnt} -le 0 ]; then
				echo "warning: an invalid TOKEN: ${TOKEN}"
				print_usage;
			fi
		;;
		-cn=*|--codename=*)
			CODE_NAME="${i#*=}"
			#-- validation
			cnt=$(curl -s "http://${IPPORT_WWES_CLUSTER}/_count?q=companies.code_name:${CODE_NAME}" | python -c "import sys, json; print json.load(sys.stdin)['count']")
			if [ ${cnt} -le 0 ]; then
				echo "warning: an invalid CODE_NAME: ${CODE_NAME}"
				print_usage;
			fi
		;;
		-uca=*|--url_cupid_api=*)
			URL_CUPID_API="${i#*=}"
			#-- validation
			status=$(curl -s -i -X GET "${URL_CUPID_API}" | grep 'HTTP' | cut -d ' ' -f 2)
			if [ -z ${status} ] || [ ${status} -ne 200 ]; then
				echo "warning: an invalid URL_CUPID_API: ${URL_CUPID_API}"
				print_usage;
			fi
		;;
	esac
done
if [ "" == "${CODE_NAME}" ] || [ "" == "${TOKEN}" ] || [ "" == "${URL_CUPID_API}" ]; then
	print_usage;
fi

echo ${CODE_NAME}
echo ${TOKEN}
echo ${URL_CUPID_API}

json_cupid_script=$(printf "$(cat ${SCRIPT_DIR}/AlsoView_COOCaContent_NoRandom_gop.json)" "${TOKEN}" "${URL_CUPID_API}" "$(date +'%Y-%m-%d %H:%M:%S')")
curl -v -X POST -H "Content-Type: application/json" -d "${json_cupid_script}" "http://${IPPORT_DHERMES_CLUSTER}/${CODE_NAME}_hermes/param2recomder"

json_cupid_script=$(printf "$(cat ${SCRIPT_DIR}/AlsoView_COOCaContent_NoRandom.json)" "${TOKEN}" "${URL_CUPID_API}"  "$(date +'%Y-%m-%d %H:%M:%S')")
curl -v -X POST -H "Content-Type: application/json" -d "${json_cupid_script}" "http://${IPPORT_DHERMES_CLUSTER}/${CODE_NAME}_hermes/param2recomder"

json_cupid_script=$(printf "$(cat ${SCRIPT_DIR}/ClickStream_COOC_p.json)" "${TOKEN}" "${URL_CUPID_API}" "$(date +'%Y-%m-%d %H:%M:%S')")
curl -v -X POST -H "Content-Type: application/json" -d "${json_cupid_script}" "http://${IPPORT_DHERMES_CLUSTER}/${CODE_NAME}_hermes/param2recomder"

json_cupid_script=$(printf "$(cat ${SCRIPT_DIR}/ClickStream_COOC.json)" "${TOKEN}" "${URL_CUPID_API}" "$(date +'%Y-%m-%d %H:%M:%S')")
curl -v -X POST -H "Content-Type: application/json" -d "${json_cupid_script}" "http://${IPPORT_DHERMES_CLUSTER}/${CODE_NAME}_hermes/param2recomder"

json_cupid_script=$(printf "$(cat ${SCRIPT_DIR}/ClickStreamInCategCode_COOC.json)" "${TOKEN}" "${URL_CUPID_API}" "$(date +'%Y-%m-%d %H:%M:%S')")
curl -v -X POST -H "Content-Type: application/json" -d "${json_cupid_script}" "http://${IPPORT_DHERMES_CLUSTER}/${CODE_NAME}_hermes/param2recomder"

