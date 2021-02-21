#! /bin/bash

DOCKER_HOME=$(dirname $0)/docker
DOCKER_COMPOSE="docker-compose -f ${DOCKER_HOME}/docker-compose.yml "
. .env

function usage {
    cat <<EOF
$(basename ${0}) is a tool for ...

Usage:
  $(basename ${0}) [command] [<options>]

Options:
  stats|st          Dockerコンテナの状態を表示します。
  init              初期化します。
  start             すべてのDaemonを起動します。
  stop              すべてのDaemonを停止します。
  centos login      CentOSのコンテナ内にログインします。
  --version, -v     バージョンを表示します。
  --help, -h        ヘルプを表示します。
EOF
}

function version {
    echo "$(basename ${0}) version 0.0.1 "
}

case ${1} in
    stats|st)
        docker container stats
    ;;

    init)
        # 停止＆削除（コンテナ・イメージ・ボリューム）
       $DOCKER_COMPOSE down --rmi all --volumes
    ;;

    build)
        $DOCKER_COMPOSE build --no-cache
    ;;
    
    start)
        $DOCKER_COMPOSE up -d
    ;;
    
    stop)
        $DOCKER_COMPOSE down
    ;;
        
    centos)
      case ${2} in
          login)
              $DOCKER_COMPOSE exec --user ${USER} centos /bin/bash
          ;;
          *)
              usage
          ;;
      esac
    ;;
   
    help|--help|-h)
        usage
    ;;

    version|--version|-v)
        version
    ;;
    
    *)
        echo "[ERROR] Invalid subcommand '${1}'"
        usage
        exit 1
    ;;
esac


