#!/bin/sh

#工程目录
PROJDIR="/Users/mini/Documents/SVN/xiaoairen/程序/XARClinet/Project"
#ipa生成目录
PROJECT_BUILDDIR="/Users/mini/Documents/SVN/Build/xar"
#ipa svn目录
SVN_PACKAGE_ROOT="/Users/mini/Documents/SVN/xiaoairen/包/"

#app name
APPLICATION_NAME="big_gm"
#target
TARGET_NAME="big_gm"
#时间格式
TIME=`date +%Y.%m.%d_%H.%M`

#资源版本号
cd "/Users/mini/Documents/SVN/xiaoairen"
VERSION=`svn info |grep Revision: |awk '{print $2}'`

#ipaName
IPA_NAME="xar_${TIME}_rc${VERSION}_${APPLICATION_NAME}"

cd "${PROJDIR}"

#转到工程目录
cd "${PROJDIR}"
#清空之前的编译记录
xcodebuild -target "${TARGET_NAME}" -scheme "${TARGET_NAME}" -configuration Release clean
#开始编译
xcodebuild -scheme "${TARGET_NAME}" -configuration Release
#判断是否编译成功
if [ $? != 0 ]
then
exit 1
fi

#压缩成ipa,如果工程里已经配置了，可以不用重新签名
/usr/bin/xcrun -sdk iphoneos PackageApplication -v "${PROJECT_BUILDDIR}/${TARGET_NAME}/${APPLICATION_NAME}.app" -o "${PROJECT_BUILDDIR}/${TARGET_NAME}/${IPA_NAME}.ipa"

#删除老包
cd $SVN_PACKAGE_ROOT
finded_ipa=`find -f . |grep .ipa$`
svn delete $finded_ipa
svn commit -m ""

#移动新包
mv "${PROJECT_BUILDDIR}/${TARGET_NAME}" "${PROJECT_BUILDDIR}/${TIME}"
finded_ipa=`find -f $PROJECT_BUILDDIR/$TIME |grep .ipa$`
mv $finded_ipa $SVN_PACKAGE_ROOT

#上传新包
cd $SVN_PACKAGE_ROOT
finded_ipa=`find -f .|grep .ipa$`
svn add $finded_ipa
svn commit -m ""