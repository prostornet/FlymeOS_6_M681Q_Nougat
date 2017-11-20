#!/system/bin/sh

# remount system for reed|write
mount -o rw,remount /system
if [ $? -ne 0 ]; then
    echo "!!! Attention !!!"
    echo "Unable to mount system to read|write"
    exit 0
fi



# deleting chinese package
for d in com.sohu.inputmethod.sogou \
com.sankuai.meituan \
com.ss.android.article.news \
com.ximalaya.ting.android \
com.qzone \
com.jingdong.app.mall \
com.meizu.datamigration \
ctrip.android.view \
com.sina.weibo \
com.achievo.vipshop \
com.flyme.meizu.store
do
    cmd package list packages | grep $d >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "!!! Приложение $d уже удалено !!!"
        echo "---"
    else
        echo "pm uninstall $d"
        echo "!!! Удаление приложения $d !!!"
        echo "---"
    fi
done

# freezing system package
for f in com.meizu.account.pay \
com.iflytek.speechsuite \
com.meizu.mzsimcontacts \
com.meizu.net.map \
com.meizu.flyme.wallet \
com.meizu.feedback \
com.android.stk \
com.meizu.yellowpage \
com.meizu.flyme.childrenlauncher \
com.android.printspooler \
com.meizu.gamecenter.service \
com.android.printservice.recommendation \
com.svox.pico \
com.meizu.voiceassistant \
com.meizu.setup \
com.mediatek.lbs.em2.ui \
com.meizu.flyme.gamecenter \
com.amap.android.location \
com.meizu.media.life \
com.baidu.BaiduMap.meizu
do
    cmd package list packages -e | grep $f >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "!!! Приложение $f уже заморожено !!!"
        echo "---"
    else
        echo "pm disable $f"
        echo "!!! Заморозка приложения $f !!!"
        echo "---"
    fi
done

for s in /system/app/Reader \
/system/priv-app/EBook \
/system/MzApp/Mall
do
    if [ ! -d $s ]; then
        echo "Directory $s don't exist"
    fi
done


exit 0