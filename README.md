mikutter_macos_appicon
====

## これは何
Dockアイコンを起動中だけmikutterのアイコンに差し替えます。

Quartz backendなGTK (つまり、GUIの表示にXQuartz等のXサーバを用いないよう構成されたGTK) を使っている環境を想定しています。

免責：これはネタプラグインです。アプリを.app形式のApp bundleに固めてInfo.plistの中にアイコンを指定してあげるのが、macOS的には本来の姿じゃないでしょうか。

## インストール
```
mkdir -p ~/.mikutter/plugin/; git clone https://github.com/shibafu528/mikutter_macos_appicon ~/.mikutter/plugin/macos_appicon
```
