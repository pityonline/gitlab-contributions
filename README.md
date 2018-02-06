# 统计 GitLab 用户提交情况

从 [GitLab API](https://docs.gitlab.com/ee/api/README.html) 取出所有仓库指定时间内的用户提交情况，汇总成数据透视表

目前统计结果包括以下内容：

* 作者姓名
* 提交次数
* 添加行数
* 删除行数
* 变更行数
* 总活动行数

## 依赖

* perl 建议 5.20.1 或以上
* git 建议 2.16.1
* 支持数据透视表的表格工具，如 LibreOffice（可选）
* 如果在 Mac 平台上运行，需要安装 gawk

安装 perl 模块依赖，可用 [cpanm](https://metacpan.org/pod/App::cpanminus)

`cpan Mojo::UserAgent JSON`

## 使用方法

运行脚本前需要先修改 bin/gitlab_contributions.pl 中 `$host` 和 `$admin_token` 的真实值

```bash
cd bin/
time ./gitlab_contributions.pl '2018-01-01' '2018-01-07'
cat ../data/*.log > ../sample/gitlab-contributions.csv
```

## 汇总

将 csv 文件使用表格工具打开，手工制作数据透视表
