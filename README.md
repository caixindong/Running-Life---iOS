# Running-Life---iOS
[中文文档](https://github.com/caixindong/Running-Life---iOS/blob/master/README-CN.md) | [English Document](https://github.com/caixindong/Running-Life---iOS/blob/master/README.md)     
Running Life(Open Source),a runens GPS social running app,based on 	AMAP and HealthKit。

#Effect
![image](https://github.com/caixindong/Running-Life---iOS/blob/master/runninglifedemo.gif)

#Functaion
`. ` Drawing running path dynamicly    
`. ` Judge running status intelligently     
`. ` Record running data and generate a small card to share(WeChat)       
`. ` Show burning calories with Bar chart        

#Technology
`. ` MVVM architecture (now temporarily using KVOController to solve the problem of Communication between View and ViewModel, the next version will be switched to ReactiveCocoa)      
`. ` Draw running path dynamicly on AMAP    
`. ` Judge running status by CMMotionManager        
`. ` Elegant record page made by Bessel curve and frame animation    
`. ` CoreData        
`. ` HealthKit             
`. ` Implementate a view multiplexing mechanism to solve the problem of OOM    
#Present
Project reconstruction is continuing. 80% of functions have been completed(less functions about interaction with the server).Server source code is open source
,developed by my friend Ying.     
Interface documentation
：[https://github.com/yinzishao/run/blob/master/README.md](https://github.com/yinzishao/run/blob/master/README.md)    
Server source code：[https://github.com/yinzishao/run](https://github.com/yinzishao/run)    
Android version：[https://github.com/caixindong/Running-Life---Android](https://github.com/caixindong/Running-Life---Android)

#Source Core Analysis
I had written two blogs to analyse the key technology of this project(but in Chinese)：    
[开源项目Running Life 源码分析（一）](http://caixindong.leanote.com/post/%E5%BC%80%E6%BA%90%E9%A1%B9%E7%9B%AERunning-Life-%E6%BA%90%E7%A0%81%E5%88%86%E6%9E%90)     
[开源项目Running Life 源码分析（二）](http://caixindong.leanote.com/post/3f62d89981d1)



