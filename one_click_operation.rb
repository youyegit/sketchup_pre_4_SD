SETUP_DIR = File.dirname(__FILE__)
SUB_MENU_DIR = File.join(SETUP_DIR,"one_click_operation")

# 加载菜单栏
require "sketchup.rb"
Sketchup.load File.join(SUB_MENU_DIR, 'load_submenu_and_toolbar')
load_submenu_and_toolbar_main()