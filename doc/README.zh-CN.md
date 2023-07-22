
# climplot：用于绘制 Walter & Lieth 气候图的流程化工具

<!-- badges: start -->

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html)
[![Project Status: Active The project has reached a stable, usable state
and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![Licence](https://img.shields.io/badge/licence-GPL--3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0.en.html)
[![minimal R
version](https://img.shields.io/badge/R-%3E=%202.10-6666ff.svg)](https://cran.r-project.org/)
[![packageversion](https://img.shields.io/badge/Package%20version-0.1.0-orange.svg?style=flat-square)](commits/develop)
[![Last-changedate](https://img.shields.io/badge/last%20change-2023--07--22-yellow.svg)](/commits/master)
![CRAN_Status_Badge](https://img.shields.io/badge/CRAN-Not%20ready-red.svg)
<!-- badges: end -->

<img src="imgfile.png" alt="climplot logo" align="right" width="40%"/>

[climplot](https://gitee.com/auman-chan/climplot)为一个绘图软件包，旨在以更加用户友好和个性化的方式收集全球各地的关键气候数据，并绘制Walter＆Lieth气候图。

该软件包的主要作用为:

- 使用Worldclim的气候数据来获得标准化和可靠的数据，以构建 Walter＆Lieth
  气候图

- 提供更多参数定制图片样式和信息显示方式

该包提供以下函数功能:

- 获取气候数据以构建Walter＆Lieth气候图

- 绘制Walter＆Lieth气候图

- 修改气候图的配色和显示的相关信息

## 安装与加载

从[gitee](https://gitee.com)
安装最新的开发版本，请安装R包[remotes](https://cran.r-project.org/package=remotes)和[git2r](https://cran.r-project.org/package=git2r):

``` r
install.packages('remotes')
install.packages('git2r')
remotes::install_git("https://gitee.com/auman-chan/climplot.git")
```

## 使用前数据准备

Worldclim气候数据是本软件包必不可少的，由于其全球尺度栅格数据的文件较大，软件包中无法容纳需要的气候数据。因此，请在使用前从[Figshare](NULL)获取对应的气候数据集。

此数据集包括4个文件夹，共48个tif文件，其中包括年均最低气温、年均最高气温、年均降水和年极端最低气温。

## 使用示例

### 气候数据提取

使用前需要按格式整理好绘图地点的信息。这个包中的数据 `locdata` 是
导入数据格式的样例。导入的数据框必须包含5列，顺序如下:

- **No**:目标地点的序号

- **location**:目标地点的缩写

- **lon**:目标地点的经度，以十进制表示，负数表示西经

- **lat**:目标地点的纬度，以十进制表示，负数表示南纬

- **altitude**:目标地点的高度

上述列的后面允许添加其他包含信息的列，但在后续处理中将被舍弃。

在准备好气候数据集和地点信息后，向函数 `clim_extract`
导入三个气候数据集的数据框和数据集路径：

``` r
#Example data in this package
data("locdata")
#Modify the path of yours
a <- "G:/climplot/climdata/tmin"
b <- "G:/climplot/climdata/tmax"
c <- "G:/climplot/climdata/prec"

#extraction of climate data

plotdata <- clim_extract(locdata,a,b,c)
```

|  No | Altitude | Location   |      Lon |     Lat | Type           |     1 |         2 |     3 |     4 |      5 |      6 |      7 |      8 |      9 |     10 |    11 |    12 |
|----:|---------:|:-----------|---------:|--------:|:---------------|------:|----------:|------:|------:|-------:|-------:|-------:|-------:|-------:|-------:|------:|------:|
|   1 |     2025 | Motuo      |  95.3536 | 29.3042 | precipitation  | 10.10 | 20.960001 | 44.85 | 98.94 | 136.67 | 232.45 | 243.60 | 204.74 | 207.16 |  74.80 |  9.20 |  5.19 |
|   1 |     2025 | Motuo      |  95.3536 | 29.3042 | min.temprature | -1.10 |  0.600000 |  3.70 |  7.20 |  11.20 |  13.70 |  14.90 |  14.60 |  14.10 |   9.90 |  3.70 |  0.60 |
|   1 |     2025 | Motuo      |  95.3536 | 29.3042 | max.temprature | 12.30 | 13.800000 | 16.50 | 19.20 |  22.70 |  25.10 |  25.50 |  26.10 |  24.00 |  20.80 | 17.60 | 14.10 |
|   2 |     1301 | Wulianshan | 100.5000 | 24.5000 | precipitation  | 17.95 |  7.160000 | 20.38 | 37.63 |  60.43 | 158.30 | 203.94 | 187.86 | 120.89 | 103.53 | 23.70 | 26.15 |
|   2 |     1301 | Wulianshan | 100.5000 | 24.5000 | min.temprature |  6.80 |  8.500000 | 11.80 | 15.20 |  18.20 |  20.20 |  20.80 |  20.30 |  19.40 |  16.40 | 11.70 |  8.00 |
|   2 |     1301 | Wulianshan | 100.5000 | 24.5000 | max.temprature | 21.00 | 24.100000 | 26.70 | 29.00 |  30.10 |  29.00 |  28.40 |  29.00 |  27.80 |  25.30 | 23.30 | 19.90 |
|   3 |     2082 | Wawushan   | 102.9167 | 29.5000 | precipitation  |  7.88 |  8.520001 | 24.04 | 59.87 | 100.53 | 195.40 | 180.20 | 164.01 | 163.07 |  62.63 | 15.26 | 11.20 |
|   3 |     2082 | Wawushan   | 102.9167 | 29.5000 | min.temprature | -5.20 | -3.600000 |  0.00 |  4.30 |   7.70 |  10.80 |  13.70 |  13.40 |  10.30 |   5.40 |  1.00 | -3.30 |
|   3 |     2082 | Wawushan   | 102.9167 | 29.5000 | max.temprature |  4.00 |  6.100000 | 10.40 | 14.70 |  17.20 |  18.60 |  21.00 |  21.10 |  16.40 |  12.60 |  9.50 |  5.00 |

导出带有气候数据的数据框,其包含5种地点信息(与导入数据框中的相同)，以及12个月份的3种气候数值。
导出数据框架存储在此包的数据`plotdata`中，作为函数导出结果的示例。

### Walter & Lieth的气候图绘制

以`plotdata`数据为例，导入到函数`clim_plot`中：

``` r
data("plotdata")
loc <- subset(plotdata,No==2)
clim_plot(loc)
```

<img src="plot1-1.png" alt="climplot" align="center"/>

在上图中:

- 红色曲线代表气温的年际变化，蓝色曲线代表降水的年际变化。这两条曲线闭合形成了两种斑块，表示湿度和干燥程度。竖线填充的斑块代表湿润季节，散点填充的斑块代表干旱季节。与降水曲线颜色相同的多边形表示降水量大于100mm的月份，表示雨季。

- 左上角的信息包括名称、海拔高度和位置坐标。右上方为年平均气温和年平均降水量。

## 其他参考

更多参考内容请阅读软件包内的帮助文件，以及vignettes中的信息。

## 参考文献

1.  Guijarro J A (2023). climatol: Climate Tools (Series Homogenization
    and Derived Products), 4.0.0.,
    <https://CRAN.R-project.org/package=climatol>.

2.  Fick, S.E. and R.J. Hijmans, (2017). WorldClim 2: new 1km spatial
    resolution climate surfaces for global land areas. International
    Journal of Climatology 37 (12): 4302-4315.

3.  Harris, I., Osborn, T.J., Jones, P.D., Lister, D.H. (2020). Version
    4 of the CRU TS monthly high-resolution gridded multivariate climate
    dataset. Scientific Data 7: 109.

4.  Walter H & Lieth H (1960): Klimadiagramm Weltatlas. G. Fischer,
    Jena.
