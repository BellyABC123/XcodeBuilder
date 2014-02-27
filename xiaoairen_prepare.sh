#!/bin/sh
cd "/Users/mini/Documents/SVN/xiaoairen"
echo "更新中..."
svn update

rm -rf "/Users/mini/Documents/SVN/xiaoairen/Message"
mkdir "/Users/mini/Documents/SVN/xiaoairen/Message"

cp -rf "/Users/mini/Documents/SVN/xiaoairen/程序/Message" "/Users/mini/Documents/SVN/xiaoairen"

cd "/Users/mini/Documents/SVN/xiaoairen/Message"

echo "代码生成中..."
for file in *
do
    case "$file" in *.proto)
        echo $file
        ./protoc --cpp_out=. $file
    esac
done