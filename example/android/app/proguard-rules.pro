-ignorewarnings

-dontoptimize
-dontpreverify
-dontwarn android.app.**
-dontwarn android.support.**
-dontwarn sun.misc.**
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn android.support.**


-keep class sun.misc.**{*;}
-keep class android.support.** { *; }
-keep class android.app.**{*;}
-keep class **.R$* {*;}

# 倍孜混淆
-dontwarn com.beizi.fusion.**
-dontwarn com.beizi.ad.**
-keep class com.beizi.fusion.** {*; }
-keep class com.beizi.ad.** {*; }

-keep class com.qq.e.** {
    public protected *;
}

-keepattributes Exceptions,InnerClasses,Signature,Deprecated,SourceFile,LineNumberTable,*Annotation*,EnclosingMethod

-dontwarn  org.apache.**