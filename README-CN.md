# Running-Life---iOS
Running Life（开源）是基于HealthKit和高德地图开发的健康跑步助手。

#运行效果
![image](https://github.com/caixindong/Running-Life---iOS/blob/master/runninglifedemo.gif)

#功能
`. ` 动态绘制跑步路径    
`. ` 智能判别跑步状态     
`. ` 记录跑步数据生成分享小卡片、微信分享      
`. ` 条形图展示消耗卡路里    

#技术
`. ` MVVM架构(现在暂时使用KVOController来解决V与VM通信，下一个大版本可以会改用ReactiveCocoa)    
`. ` 基于高德地图实现动态绘制轨迹    
`. ` CMMotionManager判断跑步状态    
`. ` 贝塞尔曲线与帧动画实现优雅的记录页面           
`. ` CoreData    
`. ` HealthKit         
`. ` 实现一个view的复用机制解决内存暴涨的问题
#现状
项目处于不断完善和重构当中，目前实现了80%功能，还差一点点与后台交互的功能，如跑步数据同步功能，后台是我另外一个小伙伴开发，同样是开源的。      
接口文档：[https://github.com/yinzishao/run/blob/master/README.md](https://github.com/yinzishao/run/blob/master/README.md)    
后台源码：[https://github.com/yinzishao/run](https://github.com/yinzishao/run)    
安卓版本（功能比较欠缺）：[https://github.com/caixindong/Running-Life---Android](https://github.com/caixindong/Running-Life---Android)

#源码分析
对于项目一些关键的技术点我写了两篇博客来分析，大家感兴趣可以移步：    
[开源项目Running Life 源码分析（一）](http://caixindong.leanote.com/post/%E5%BC%80%E6%BA%90%E9%A1%B9%E7%9B%AERunning-Life-%E6%BA%90%E7%A0%81%E5%88%86%E6%9E%90)     
[开源项目Running Life 源码分析（二）](http://caixindong.leanote.com/post/3f62d89981d1)



