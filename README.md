# Shared-Source
An app to ask development questions or post bits of code for others to check out

## Compiling:
1. Clone repo
2. cd /path/to/project
3. "pod init"
4. Open podfile and add these pods (including ''):

    pod 'Firebase/Core'
    
    pod 'Firebase/Auth'
    
    pod 'Firebase/Database'
    
    pod 'Firebase/Storage'
    
5. Save podfile
6. "pod install"
7. Open .xcworkspace and compile
