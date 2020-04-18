---
title: fuck-oems
date: 2020-04-17 21:45:31
tags:
---

I personally think that one of the problems with Android ecosystem is Android device manufacturers (OEM's) altering platform code and implementing hardware in a shitty way. 

I believe that the OEM's intentions are pure: Make the device stand out, give great user experience, make things look pretty and save power. Often times it comes with a cost: Fragmentation: things performing differently on different devices, random ANR crashes and device dependant problems, Services being killed for "power saving", whitelisting for popular apps, you name it.

It comes with a cost. One of the biggest points of interests I have noticed is the difference between video playback on different devices:

One of the problems with playing video content on android devices is the codec / hardware implementations of devices: [Issue 4468](https://github.com/google/ExoPlayer/issues/4468) [Issue 6899](https://github.com/google/ExoPlayer/issues/6899) [Issue 6222](https://github.com/google/ExoPlayer/issues/6222) 

Exoplayer, the most popular and stable video / streaming library for Android keeps a list of devices that need a workaround to get around of the device implementation bugs to smoothly play videos:

```
/**
   * Returns whether the codec is known to implement {@link MediaCodec#setOutputSurface(Surface)}
   * incorrectly.
   *
   * <p>If true is returned then we fall back to releasing and re-instantiating the codec instead.
   *
   * @param name The name of the codec.
   * @return True if the device is known to implement {@link MediaCodec#setOutputSurface(Surface)}
   *     incorrectly.
   */
  protected boolean codecNeedsSetOutputSurfaceWorkaround(String name) {
    if (name.startsWith("OMX.google")) {
      // Google OMX decoders are not known to have this issue on any API level.
      return false;
    }
    synchronized (MediaCodecVideoRenderer.class) {
      if (!evaluatedDeviceNeedsSetOutputSurfaceWorkaround) {
        if (Util.SDK_INT <= 27 && "dangal".equals(Util.DEVICE)) {
          // A small number of devices are affected on API level 27:
          // https://github.com/google/ExoPlayer/issues/5169.
          deviceNeedsSetOutputSurfaceWorkaround = true;
        } else if (Util.SDK_INT >= 27) {
          // In general, devices running API level 27 or later should be unaffected. Do nothing.
        } else {
          // Enable the workaround on a per-device basis. Works around:
          // https://github.com/google/ExoPlayer/issues/3236,
          // https://github.com/google/ExoPlayer/issues/3355,
          // https://github.com/google/ExoPlayer/issues/3439,
          // https://github.com/google/ExoPlayer/issues/3724,
          // https://github.com/google/ExoPlayer/issues/3835,
          // https://github.com/google/ExoPlayer/issues/4006,
          // https://github.com/google/ExoPlayer/issues/4084,
          // https://github.com/google/ExoPlayer/issues/4104,
          // https://github.com/google/ExoPlayer/issues/4134,
          // https://github.com/google/ExoPlayer/issues/4315,
          // https://github.com/google/ExoPlayer/issues/4419,
          // https://github.com/google/ExoPlayer/issues/4460,
          // https://github.com/google/ExoPlayer/issues/4468,
          // https://github.com/google/ExoPlayer/issues/5312.
          switch (Util.DEVICE) {
            case "1601":
            case "1713":
            case "1714":
            case "A10-70F":
            case "A10-70L":
            case "A1601":
            case "A2016a40":
            case "A7000-a":
            case "A7000plus":
            case "A7010a48":
            case "A7020a48":
            case "AquaPowerM":
            case "ASUS_X00AD_2":
            case "Aura_Note_2":
            case "BLACK-1X":
            case "BRAVIA_ATV2":
            case "BRAVIA_ATV3_4K":
            case "C1":
            case "ComioS1":
            case "CP8676_I02":
            case "CPH1609":
            case "CPY83_I00":
            case "cv1":
            case "cv3":
            case "deb":
            case "E5643":
            case "ELUGA_A3_Pro":
            case "ELUGA_Note":
            case "ELUGA_Prim":
            case "ELUGA_Ray_X":
            case "EverStar_S":
            case "F3111":
            case "F3113":
            case "F3116":
            case "F3211":
            case "F3213":
            case "F3215":
            case "F3311":
            case "flo":
            case "fugu":
            case "GiONEE_CBL7513":
            case "GiONEE_GBL7319":
            case "GIONEE_GBL7360":
            case "GIONEE_SWW1609":
            case "GIONEE_SWW1627":
            case "GIONEE_SWW1631":
            case "GIONEE_WBL5708":
            case "GIONEE_WBL7365":
            case "GIONEE_WBL7519":
            case "griffin":
            case "htc_e56ml_dtul":
            case "hwALE-H":
            case "HWBLN-H":
            case "HWCAM-H":
            case "HWVNS-H":
            case "HWWAS-H":
            case "i9031":
            case "iball8735_9806":
            case "Infinix-X572":
            case "iris60":
            case "itel_S41":
            case "j2xlteins":
            case "JGZ":
            case "K50a40":
            case "kate":
            case "le_x6":
            case "LS-5017":
            case "M5c":
            case "manning":
            case "marino_f":
            case "MEIZU_M5":
            case "mh":
            case "mido":
            case "MX6":
            case "namath":
            case "nicklaus_f":
            case "NX541J":
            case "NX573J":
            case "OnePlus5T":
            case "p212":
            case "P681":
            case "P85":
            case "panell_d":
            case "panell_dl":
            case "panell_ds":
            case "panell_dt":
            case "PB2-670M":
            case "PGN528":
            case "PGN610":
            case "PGN611":
            case "Phantom6":
            case "Pixi4-7_3G":
            case "Pixi5-10_4G":
            case "PLE":
            case "PRO7S":
            case "Q350":
            case "Q4260":
            case "Q427":
            case "Q4310":
            case "Q5":
            case "QM16XE_U":
            case "QX1":
            case "santoni":
            case "Slate_Pro":
            case "SVP-DTV15":
            case "s905x018":
            case "taido_row":
            case "TB3-730F":
            case "TB3-730X":
            case "TB3-850F":
            case "TB3-850M":
            case "tcl_eu":
            case "V1":
            case "V23GB":
            case "V5":
            case "vernee_M5":
            case "watson":
            case "whyred":
            case "woods_f":
            case "woods_fn":
            case "X3_HK":
            case "XE2X":
            case "XT1663":
            case "Z12_PRO":
            case "Z80":
              deviceNeedsSetOutputSurfaceWorkaround = true;
              break;
            default:
              // Do nothing.
              break;
          }
          switch (Util.MODEL) {
            case "AFTA":
            case "AFTN":
              deviceNeedsSetOutputSurfaceWorkaround = true;
              break;
            default:
              // Do nothing.
              break;
          }
        }
        evaluatedDeviceNeedsSetOutputSurfaceWorkaround = true;
      }
    }
    return deviceNeedsSetOutputSurfaceWorkaround;
  }
```

This sounds like a problem from the past, but I have seen an increase of problems coming from Huawei devices regarding of this issue. Also specific AndroidTV devices have been affected. 


This problem also extends to playing DRM content on devices. Because of buggy implementations of DRM / bad certificates, sometimes the only way to reliably play DRM content on Android device is using software decoding for DRM (level 3), which causes horrible lag, performance problems and decrease in quality.

[source1](https://www.smartprix.com/bytes/redmi-note-5-pro-honor-9-lite-affordable-phones-dont-support-hd-streaming-netflix-amazon-prime/) [source2](https://www.xda-developers.com/android-netflix-hd-amazon-prime-video-hd-drm/) [source3](https://c.mi.com/thread-1829938-1-1.html)

What is even worse, imo, is the problems with native views such as VideoView, working differently on different devices. 

Playing a simple video (mp4) causes certain Huawei devices to crash:

```
#00  pc 000000000006fd98  /system/lib64/libc.so (__ioctl+4)
  #01  pc 0000000000029e34  /system/lib64/libc.so (ioctl+136)
  #02  pc 000000000006b4f0  /system/lib64/libbinder.so (android::IPCThreadState::talkWithDriver(bool)+256)
  #03  pc 000000000006c7f4  /system/lib64/libbinder.so (android::IPCThreadState::waitForResponse(android::Parcel*, int*)+60)
  #04  pc 000000000006c470  /system/lib64/libbinder.so (android::IPCThreadState::transact(int, unsigned int, android::Parcel const&, android::Parcel*, unsigned int)+240)
  #05  pc 0000000000061e74  /system/lib64/libbinder.so (android::BpBinder::transact(unsigned int, android::Parcel const&, android::Parcel*, unsigned int)+72)
  #06  pc 00000000000771fc  /system/lib64/libmedia.so (android::BpMediaPlayer::setDataSource(int, long, long)+300)
  #07  pc 0000000000065ebc  /system/lib64/libmedia.so (android::MediaPlayer::setDataSource(int, long, long)+592)
  #08  pc 00000000000461a0  /system/lib64/libmedia_jni.so (android_media_MediaPlayer_setDataSourceFD(_JNIEnv*, _jobject*, _jobject*, long, long)+180)
  at android.media.MediaPlayer._setDataSource (MediaPlayer.java)
  at android.media.MediaPlayer.setDataSource (MediaPlayer.java:1382)
  at android.media.MediaPlayer.setDataSource (MediaPlayer.java:1349)
  at android.media.MediaPlayer.attemptDataSource (MediaPlayer.java:1177)
  at android.media.MediaPlayer.setDataSource (MediaPlayer.java:1148)
  at android.media.MediaPlayer.setDataSource (MediaPlayer.java:1172)
  at android.widget.VideoView.openVideo (VideoView.java:402)
  at android.widget.VideoView.setVideoURI (VideoView.java:274)
  at android.widget.VideoView.setVideoURI (VideoView.java:257)
  at XXXX
  at android.os.Handler.handleCallback (Handler.java:907)
  at android.os.Handler.dispatchMessage (Handler.java:105)
  at android.os.Looper.loop (Looper.java:216)
  at android.app.ActivityThread.main (ActivityThread.java:7625)
  at java.lang.reflect.Method.invoke (Method.java)
  at com.android.internal.os.RuntimeInit$MethodAndArgsCaller.run (RuntimeInit.java:524)
  at com.android.internal.os.ZygoteInit.main (ZygoteInit.java:987)

```

```
By device
P20 Pro (HWCLT)	27
Honor 10 (HWCOL)	16
HUAWEI P smart 2019 (HWPOT-H)	10
P20 (HWEML)	9
Others	23
P20 Pro (HWCLT)	27	31.8%
Honor 10 (HWCOL)	16	18.8%
HUAWEI P smart 2019 (HWPOT-H)	10	11.8%
P20 (HWEML)	9	10.6%
Mate 10 Pro (HWBLA)	6	7.1%
Honor Play (HWCOR)	5	5.9%
honor 10 Lite (HWHRY-H)	5	5.9%
HUAWEI P30 lite (HWMAR)	4	4.7%
HONOR 10i (HWHRY-HF)	2	2.4%
HUAWEI Y9 Prime 2019 (HWSTK-HF)	1	1.2%
```

Unless Google is playing some kind of crazy sleight of hand towards Huawei (its not impossible), it seems to be that some device OEM's are in the right of blame in here.





`- Zudoku`