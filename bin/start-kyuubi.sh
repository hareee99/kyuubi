#!/usr/bin/env bash

#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

export SPARK_HOME=/Users/Kent/Documents/spark

## Kyuubi Server Main Entrance
CLASS="yaooqinn.kyuubi.server.KyuubiServer"

function usage {
  echo "Usage: ./bin/start-kyuubi.sh <args...>"
}

if [[ "$@" = *--help ]] || [[ "$@" = *-h ]]; then
  usage
  exit 0
fi

## Find the Kyuubi Jar
KYUUBI_JAR_DIR="$(cd "`dirname "$0"`"/..; pwd)/target"
KYUUBI_JAR_NUM="$(ls ${KYUUBI_JAR_DIR} | grep kyuubi- | grep .jar | wc -l)"

if [ ${KYUUBI_JAR_NUM} = "0" ]; then
  echo "Kyuubi Server: need to build kyuubi first. Run ./bin/mvn clean package" >&2
  exit 1
fi

if [ ${KYUUBI_JAR_NUM} != "1" ]; then
  echo "Kyuubi Server: duplicated kyuubi jars found. Run ./bin/mvn clean package" >&2
  exit 1
fi

KYUUBI_JAR=${KYUUBI_JAR_DIR}/"$(ls ${KYUUBI_JAR_DIR} |grep kyuubi- | grep .jar)"

echo "Kyuubi Server: jar founded:" ${KYUUBI_JAR} >&2

exec "${SPARK_HOME}"/sbin/spark-daemon.sh submit ${CLASS} 1 "$@" "$KYUUBI_JAR"

