#Anaconda Python
export CONDA_HOME=/usr/local/anaconda3
export PATH=$CONDA_HOME/bin:$PATH

# nginx
export NGINX_HOME=/usr/local/Cellar/nginx-full/1.12.1/bin
export PATH=$NGINX_HOME:$PATH
# repo
export REPO_HOME=/Users/silen/bin
export PATH=$REPO_HOME:$PATH
# OpenCV
#export OPENCV_HOME=/usr/local/opt/opencv
export OPENCV_HOME=/usr/local/opt/opencv3
export PATH=$OPENCV_HOME/bin:$PATH
# Java Env
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_121.jdk/Contents/Home
export JRE_HOME=$JAVA_HOME/jre
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export PATH=$JAVA_HOME/bin:$PATH

# Android toolchain.里面的python和环境中变量冲突
export PATH=$PATH:$HOME/my-android-toolchain/bin

# SDK和NDK
export ANDROID_HOME=/Users/silen/Library/Android/sdk
export PATH=$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$PATH
#export ANDROID_NDK=/Users/silen/Library/Android/sdk/ndk-bundle
#export ANDROID_NDK_HOME=/Users/silen/Android/ndk/android-ndk-r10d
export ANDROID_NDK=/Users/silen/Android/ndk/android-ndk-r12b
export PATH=$ANDROID_NDK_HOME:$PATH

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm

# depot_tools谷歌编译工具
#export PWD=/Users/silen/Programs/depot_tools
#export PATH=$PWD:$PATH

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/silen/.sdkman"
[[ -s "/Users/silen/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/silen/.sdkman/bin/sdkman-init.sh"

#ngrok
export NGROK_HOME="/Users/silen/.ngrok"
export PATH=$NGROK_HOME:$PATH

#python
#export PY_ROOT=$HOME/.pyenv
export PY_ROOT="/usr/local/Cellar/python/2.7.14_2"
export PATH=$PY_ROOT/bin:$PATH
#eval "$(pyenv init -)"

#golang
export GOROOT="/usr/local/Cellar/go/1.9.3/libexec"
export GOPATH=$HOME/Go
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin
