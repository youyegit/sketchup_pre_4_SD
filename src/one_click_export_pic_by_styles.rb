def export_image_with_style(model,style_name,shadow_info_input)
  # 获取当前视图
  view = model.active_view
  # 获取当前脚本路径,拼接样式文件路径
  style_file = File.join(SUB_MENU_DIR, "#{style_name}.style")
  puts "要加载的样式路径：#{style_file}"
  # 保存当前视图样式
  original_style = model.styles.selected_style
  # 清除未使用的样式
  # model.styles.purge_unused
  # 获取导入的样式
  model.styles.add_style(style_file, style_name)
  # style = model.styles[style_name]

  style = nil
  model.styles.each do |s|
    if s.name == style_name
      style = s
    end
  end

  # 设置导入的样式为当前选中样式
  if style.nil?
    puts "加载样式失败"
  else
    model.styles.selected_style = style 
    puts "加载样式成功：#{style_name}"
  end

  # 刷新视图
  view.refresh

  # 保存原始阴影设置
  shadow_info = model.shadow_info
  original_display_shadows_value = shadow_info["DisplayShadows"]
  original_use_sun_for_all_shading_value = shadow_info["UseSunForAllShading"]
  original_light_value = shadow_info["Light"]
  original_dark_value = shadow_info["Dark"]
  # 设置阴影参数，使用阳光参数区分明暗面，并设置亮度和暗度
  shadow_info["DisplayShadows"] = shadow_info_input["DisplayShadows"]
  shadow_info["UseSunForAllShading"] = shadow_info_input["UseSunForAllShading"]
  shadow_info["Light"] = shadow_info_input["Light"]
  shadow_info["Dark"] = shadow_info_input["Dark"]

  # 导出图片
  image_path = image_path_handled(model)
  options = render_options(view,image_path)
  view.write_image(options)

  # 恢复原始视图样式和阴影设置
  sleep(2)
  model.styles.selected_style = original_style
  # 本来想删除导入的样式，但是还找不到单独删除某个样式的方式
  shadow_info["DisplayShadows"] = original_display_shadows_value
  shadow_info["UseSunForAllShading"] = original_use_sun_for_all_shading_value
  shadow_info["Light"] = original_light_value
  shadow_info["Dark"] = original_dark_value

  puts "图片导出完成：#{image_path}"
end

def active_view_to_pic(model)
  # 获取当前视图
  view = model.active_view

  # 导出图片
  image_path = image_path_handled(model)
  options = render_options_simple(view,image_path)
  view.write_image(options)

  puts "图片导出完成：#{image_path}"
end

def render_options(view,image_path)
  # 获取当前窗口的高和宽
  width = view.vpwidth
  height = view.vpheight
  # 如果宽或高大于2048，则等比例缩小到2048以下
  if width > 2048 || height > 2048
    scale_factor = [2048.0 / width, 2048.0 / height].min
    width = (width * scale_factor).to_i # 截取数字的整数部分
    height = (height * scale_factor).to_i
  end
  puts "导出图片的宽度和高度为：\nwidth: #{width} \nheight: #{height}"
  # 修改渲染参数，以便完全按照图层颜色导出图片
  options = {
    :filename => image_path, # 文件名
    :antialias => true, # 抗锯齿
    :compression => 1, # 压缩比
    :transparent => false, # 透明度
    :dither => false,# 抖动
    :width => width, # 设置导出图片的宽度
    :height => height, # 设置导出图片的高度
    :viewbased => false, # 根据视图设置导出图片的大小
    :displayviewbackground => false, # 不显示视图背景
    :monochrome => true # 禁用明暗面区分
  }
  return options
end

def render_options_simple(view,image_path)
  # 获取当前窗口的高和宽
  width = view.vpwidth
  height = view.vpheight
  # 如果宽或高大于2048，则等比例缩小到2048以下
  if width > 2048 || height > 2048
    scale_factor = [2048.0 / width, 2048.0 / height].min
    width = (width * scale_factor).to_i # 截取数字的整数部分
    height = (height * scale_factor).to_i
  end
  puts "导出图片的宽度和高度为：\nwidth: #{width} \nheight: #{height}"
  # 修改渲染参数，以便完全按照图层颜色导出图片
  options = {
    :filename => image_path, # 文件名
    :antialias => true, # 抗锯齿
    :compression => 1, # 压缩比
    # :transparent => false, # 透明度
    # :dither => false,# 抖动
    :width => width, # 设置导出图片的宽度
    :height => height, # 设置导出图片的高度
    # :viewbased => false, # 根据视图设置导出图片的大小
    # :displayviewbackground => false, # 不显示视图背景
    # :monochrome => true # 禁用明暗面区分
  }
  return options
end

def image_path_handled(model)
  # 获取sketchup文件的目录和名称
  path = model.path
  # 获取父路径
  dir = File.dirname(path)
  # 获取不带后缀的文件名
  name = File.basename(path).chomp(".skp")

  # 定义存储图片的文件夹名称
  image_output_folder = "image_output"
  image_output_folder_dir = File.join(dir,image_output_folder)
  Dir.mkdir(image_output_folder_dir) unless Dir.exist?(image_output_folder_dir)

  # 拼接路径和文件名
  path = File.join(image_output_folder_dir, name)

  # 获取当前日期和时间，格式为YYYYMMDDHHMMSS
  time = Time.now.strftime("%Y%m%d_%H%M%S")
  # 组合路径
  filename = File.join(path + "_" + time + ".png")
  return filename
end

def export_layer_colors_main()
  require 'sketchup'
  # require 'fileutils'
  model = Sketchup.active_model # 获取当前活动模型
  # 这个样式名称最好导出的时候就确定了，跟sketchup里的名称一致，
  # 否则就算文件名改了，后续加载还是原来的
  style_name = 'OnlyTagColorsDisplayedAddSky'
  shadow_info_input = {
    "DisplayShadows" => false,
    "UseSunForAllShading" => true,
    "Light" => 0,
    "Dark" => 80
  }
  export_image_with_style(model,style_name,shadow_info_input)
end

def export_lineart_main()
  require 'sketchup'
  # require 'fileutils'
  model = Sketchup.active_model # 获取当前活动模型
  # 这个样式名称最好导出的时候就确定了，跟sketchup里的名称一致，
  # 否则就算文件名改了，后续加载还是原来的
  style_name = 'OnlyLineDisplayed'
  shadow_info_input = {
    "DisplayShadows" => false,
    "UseSunForAllShading" => true,
    "Light" => 0,
    "Dark" => 0
  }
  export_image_with_style(model,style_name,shadow_info_input)
end

def screenshot_main()
  require "sketchup.rb"
  model = Sketchup.active_model
  active_view_to_pic(model) 
end


# #============创建自定义菜单============== 
# cmd = UI::Command.new('一键截图'){
    # SUB_MENU_DIR = File.dirname(__FILE__)
#   export_layer_colors_main()
#   export_lineart_main()
#   }
# menu = UI.menu('extensions')
# menu.add_item(cmd)

# export_layer_colors_main()

# #============创建自定义菜单============== 
# cmd = UI::Command.new('一键截图'){
#   screenshot_main()
#   }
# menu = UI.menu('extensions')
# menu.add_item(cmd)

# screenshot_main()