The CompileOptions.bootClasspath property has been deprecated and is scheduled to be removed in Gradle 5.0. Please use the CompileOptions.bootstrapClasspath property instead.

> ```groovy
> android {
>
>     compileOptions {
>         sourceCompatibility JavaVersion.VERSION_1_8
>         targetCompatibility JavaVersion.VERSION_1_8
>     }
> }
> ```



Error:Execution failed for task ':app:transformClassesWithDesugarFor_walleDebug'.

> com.android.build.api.transform.TransformException: java.lang.RuntimeException: java.lang.RuntimeException: com.android.ide.common.process.ProcessException: Error while executing java process with main class 



Error:Unable to resolve dependency for ':app@debug/compileClasspath': Could not resolve project :library.

> Android Studio 2.3 迁移 到3.0 问题 
>
> [解决方案](https://majing.io/posts/10000003061192)