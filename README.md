#Gemini
---
Gemini compares 2 directories and tells if they are the same

###How to use?
You need to drag and drop folders to each folder icon and press *compare* button to start. While comparison is in the process you can press *Esc* to cancel operation. As the result, you'll see modal screen with summary.
*Note* There is 3 seconds delay before comparison operation starts. That was implemented because comparison works pretty fast (at least with small directories ), so animation doesn't look so cool.

###How do animation works?
Animation done in 2 ways. Folders animate by chaging layout constraints constants. Xray animates using Core Animation.

###How do comparison works?
Given directories parsed into 'Folder' struct. It contains map 2 properties:
files: [String: String]   // [hash : name]
folders: [String: Folder] // [relativePath : folder]

###Hey, what about ignore-list?
It is implemented in 'GeminiManager'. You need to pass an array of strings that contains file name patterns that needs to be ignored. You can specify file name and extension for exact matching or you can use * to ignore file or extensions or both parts.

###What about drag'n'drop?
Just found somewhere at the internet, and modified so now it accepts only folders. Behavior could be changed by modifying 'checkExtension' method in 'FolderPickerImageView' class.

###Which 3rd party libs used?
'ReactiveCocoa'. Yeah, I know that OSX natively supports bindings, but I'm not so familiar with them for NOW.
