
/*
 
 1.使用数据库
 需要添加 libsqlite3.tbd 
 ( Build Phases ---> Link Binary With Library )
 
 2.对于使用base64  与RC4  需要添加 非arc编译: -fno-objc-arc
 ( Build Phases ---> Compile Source --->Base64.m/RC4.m )
 旧工程配置acr：-fobjc-arc
 
 3. 3D Touch 在appdelegate 直接调用 MSDPreventImagePickerCrashOn3DTouch()
 
 */
