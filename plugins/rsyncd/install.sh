#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH


curPath=`pwd`
rootPath=$(dirname "$curPath")
rootPath=$(dirname "$rootPath")
serverPath=$(dirname "$rootPath")
sysName=`uname`

install_tmp=${rootPath}/tmp/mw_install.pl
Install_rsyncd()
{
	echo '正在安装脚本文件...' > $install_tmp
	mkdir -p $serverPath/rsyncd

	
	echo '1.0' > $serverPath/rsyncd/version.pl
	echo '安装完成' > $install_tmp
	cd ${rootPath} && python3 ${rootPath}/plugins/rsyncd/index.py start
	cd ${rootPath} && python3 ${rootPath}/plugins/rsyncd/index.py initd_install
}

Uninstall_rsyncd()
{
	if [ -f /lib/systemd/system/rsyncd.service ];then
		systemctl stop rsyncd
		systemctl disable rsyncd
		rm -rf /lib/systemd/system/rsyncd.service
		systemctl daemon-reload
	fi

	if [ -f $serverPath/rsyncd/initd/rsyncd ];then
		$serverPath/rsyncd/initd/rsyncd stop
	fi
	rm -rf $serverPath/rsyncd
	echo "卸载完成" > $install_tmp
}

action=$1
if [ "${1}" == 'install' ];then
	Install_rsyncd
else
	Uninstall_rsyncd
fi
