def load_items(submenu, mytoolbar)
    # 加载ade20k.csv导入图层
    Sketchup.load File.join(SUB_MENU_DIR, 'ade20k_csv_import_layer')
    cmd1 = UI::Command.new('一键导入语义分割图层') {
      import_layer_main()
    }
    
    Sketchup.load File.join(SUB_MENU_DIR, 'one_click_export_pic_by_styles')
    # 加载一键导出图层
    cmd2_1 = UI::Command.new('一键导出图层颜色') {
        export_layer_colors_main()
    }
    cmd2_1.tooltip = "导出图层颜色" # 提示信息
    cmd2_1.status_bar_text = "按图层颜色导出png图片,会新增一个样式，可以删除但不要修改它。图片宽高限制在2048以下。"

    # 加载一键导出线稿
    cmd2_2 = UI::Command.new('一键导出线稿') {
        export_lineart_main()
      }
    cmd2_2.tooltip = "导出线稿" # 提示信息
    cmd2_2.status_bar_text = "按黑线白底导出png图片,会新增一个样式，可以删除但不要修改它。图片宽高限制在2048以下。"

    # 加载一键导出图层 + 导出线稿
    cmd2_plus = UI::Command.new('一键导出图层颜色 + 线稿') {
        export_layer_colors_main()
        sleep(2)
        export_lineart_main()
    }
    cmd2_plus.tooltip = "导出图层颜色 + 线稿" # 提示信息
    cmd2_plus.status_bar_text = "一键导出图层颜色 + 一键导出线稿 的命令组合，会导出两张图。要多等一会。"

    # 加载一键截图
    cmd3 = UI::Command.new('一键截图') {
        screenshot_main()
    }
    cmd3.tooltip = "截图" # 提示信息
    cmd3.status_bar_text = "按当前窗口显示，导出png图片。图片宽高限制在2048以下。"

    # 图标
    cmd2_1.small_icon = "icon/icon_small_2.png" # 小尺寸16*16
    cmd2_1.large_icon = "icon/icon_large_2.png" # 大尺寸24*24
    cmd2_2.small_icon = "icon/icon_small_2_2.png" # 小尺寸16*16
    cmd2_2.large_icon = "icon/icon_large_2_2.png" # 大尺寸24*24
    cmd2_plus.small_icon = "icon/icon_small_2_plus.png" # 小尺寸16*16
    cmd2_plus.large_icon = "icon/icon_large_2_plus.png" # 大尺寸24*24
    cmd3.small_icon = "icon/icon_small_3.png" # 小尺寸
    cmd3.large_icon = "icon/icon_large_3.png" # 大尺寸

    # 加入子菜单
    submenu.add_item(cmd1)
    submenu.add_item(cmd2_1)
    submenu.add_item(cmd2_2)
    submenu.add_item(cmd2_plus)
    submenu.add_item(cmd3)  

    # 加入工具栏
    mytoolbar.add_item(cmd2_1)
    mytoolbar.add_item(cmd2_2)
    mytoolbar.add_item(cmd2_plus)
    mytoolbar.add_item(cmd3)
end

def load_submenu_and_toolbar_main()
    require "sketchup.rb"
    # 创建主菜单
    menu = UI.menu
    submenu = menu.add_submenu('一键操作')

    # 创建工具栏
    mytoolbar = UI::Toolbar.new("TDXH-toolbar")

    # 加载
    load_items(submenu, mytoolbar)

    # 显示
    mytoolbar.show
end

# SUB_MENU_DIR = File.dirname(__FILE__)
# load_submenu_and_toolbar_main()
  