#!/system/bin/sh
########################
# Arrays with packages #
########################
apps_del=( com.sohu.inputmethod.sogou com.sankuai.meituan com.ss.android.article.news com.ximalaya.ting.android com.qzone com.jingdong.app.mall com.meizu.datamigration ctrip.android.view com.sina.weibo com.achievo.vipshop com.flyme.meizu.store com.baidu.BaiduMap.meizu com.meizu.datamigration )
apps_freeze=( com.meizu.account.pay com.iflytek.speechsuite com.meizu.mzsimcontacts com.meizu.net.map com.meizu.flyme.wallet com.android.stk com.meizu.flyme.childrenlauncher com.android.printspooler com.meizu.gamecenter.service com.android.printservice.recommendation com.svox.pico com.meizu.voiceassistant com.meizu.setup com.mediatek.lbs.em2.ui com.meizu.flyme.gamecenter com.amap.android.location com.meizu.media.life )
apps_del_sys=( /system/app/Reader /system/priv-app/EBook /system/MzApp/Mall /system/priv-app/Feedback /system/priv-app/YellowPage )
#################
# Set main path #
#################
PATH1=/data/local/tmp/files/
PATH2=/system/
PATH3=/vendor
#################
# Check user ID #
#################
#pm list users | sed 1d | cut -d: -f1 | sed 's/^[ \t]*//;s/UserInfo{//' >/dev/null 2>&1
#if [ $? -ne 0 ]; then
#    echo "!!! Attention !!!"
#    echo "You are not root. First execute su command and then execute script."
#    exit 0
#fi
#
#################################
# Remount system for reed|write #
#################################
echo "[1.] Checking ..."
mount -o rw,remount /system
if [ $? -ne 0 ]; then
    echo "!!! Attention !!! Unable to mount system to read|write"
    exit 0
fi

############################
# Deleting chinese package #
############################
echo " "
echo "[2.] Deleting chinese apps ..."
echo " "
for ad in "${apps_del[@]}"
do
    cmd package list packages | grep $ad >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "!!.d.!! App $ad is already deleted ..."
    else
        pm uninstall $ad
        echo "!!.d.!! Deleting app $ad ..."
    fi
done

###########################
# Freezing system package #
###########################
echo " "
echo "[3.] Feezing chinese apps ..."
echo " "
for af in "${apps_freeze[@]}"
do
    cmd package list packages -e | grep $af >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "!!.f.!! App $af is already freezed ..."
    else
        pm disable $af
        echo "!!.f.!! Freezing app $af ..."
    fi
done

########################
# Deleting system apps #
########################
echo " "
echo "[4.] Deleting system apps ..."
echo " "
for ads in "${apps_del_sys[@]}"
do
    if [ -d $ads ]; then
        rm -rf $ads
        echo "!!.d.!! Deleting system app $ads"
    fi
done

##############################
# Translate chinese firmware #
##############################
echo " "
echo "[5.] Translation firmware"
echo " "
if [ -d /storage/emulated/0/files ]; then
    mv /storage/emulated/0/files/ $PATH1
    if [ $? -ne 0 ]; then
        echo "!!! Attention !!! Unable to move files"
        exit 0
    fi
else
    echo "!!! Attention !!! No folder files on sdcard"
    exit 0
fi
find $PATH1 -type f -exec chmod 644 {} \;
find $PATH1 -type d -exec chmod 755 {} \;

cp -r ${PATH1}priv-app/* ${PATH2}priv-app >/dev/null 2>&1
cp -r ${PATH1}app/* ${PATH2}app >/dev/null 2>&1
cp -r ${PATH1}framework/* ${PATH2}framework >/dev/null 2>&1
cp -r ${PATH1}vendor/* ${PATH3} >/dev/null 2>&1
cp -r ${PATH1}build.prop ${PATH2} >/dev/null 2>&1

rm -r ${PATH1}
echo "!!! Finish translation, reboot device..."
sleep 5
reboot


exit 0