def csv_to_layers(model,file_name)
  layers = model.layers # 获取图层集合
    
  # 获取文件路径,同脚本路径
  # base_path = File.dirname(__FILE__)
  base_path = SUB_MENU_DIR
  file_path = File.join(base_path, file_name)
  puts "File to input: #{file_path}"

  unless File.exist?(file_path) # 如果文件不存在
    UI.messagebox("#{file_path}的文件不存在") # 提示用户
    puts "Loading failed"
    return false
  end

  # 定义两个变量，用来记录新建和已存在的图层数量
  new_count = 0
  exist_count = 0

  # CSV.foreach(file_path) do |row| # 遍历csv文件的每一行
  CSV.foreach(file_path).with_index(1) do |row, line_number| # 遍历csv文件的每一行并获取行号
    r, g, b, name = row # 将每一行的四列分别赋值给r, g, b, name
    name = "#{line_number} - #{name}" # 在name前添加行号和"-"
    color = Sketchup::Color.new(r.to_i, g.to_i, b.to_i) # 根据RGB值创建颜色对象
    layer = layers[name] # 根据名称查找是否已经存在该图层
    if layer.nil? # 如果不存在该图层
      layer = layers.add(name) # 则新建一个图层
      layer.color = color # 并设置其颜色
      new_count += 1 # 新建图层数量加一
    else # 如果存在该图层
      layer.color = color # 修改该图层的颜色
      exist_count += 1 # 已存在图层数量加一
    end
  end
  # 提示成功消息
  puts "Loading successfully"
  UI.messagebox("ade20k图层新建完成!\n一共新建了#{new_count}个图层，有#{exist_count}个图层是已经存在的。")
  return true

end

def import_layer_main()
  require 'sketchup.rb'
  require 'csv' # 引入CSV模块
  model = Sketchup.active_model # 获取当前模型
  file_name = "ade20k_zh.csv"
  csv_to_layers(model,file_name)
end 

# #============创建自定义菜单============== 
# cmd = UI::Command.new('ade20k.csv导入图层'){
#   main()
# }
# menu = UI.menu('extensions')
# menu.add_item(cmd)

# main()

