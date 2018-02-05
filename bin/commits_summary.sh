#!/bin/bash

since_time=$1
until_time=$2
group_name=$3
repo_name=$4
repo_url=$5     # 不需要更新最新状态时注释掉

pull_update() {
    # 此处以 develop 分支作为主干分支，按需修改
    # 如果可切换 develop 分支则拉取 develop 分支更新，否则在默认分支上拉取更新
    if git checkout -q develop; then
        git pull -v -f origin develop || echo "Pull develop failed!"
    else
        git pull -v -f || echo "Pull develop failed!"
    fi

    # go_back
    # cd ../../ || echo "Cannot go back!"
}

# testing
go_back() {
    cd ../../ || echo "Cannot go back!"
}

clone_repo() {
    mkdir -p "../repos/$group_name" || echo "$group_name exists!"
    cd "../repos/$group_name" && git clone "$repo_url" 2>/dev/null

    # go_back
    cd ../ || echo "Cannot go back!"
}

commits_summary() {
    cd "../repos/$group_name/$repo_name" && pull_update || echo "$group_name/$repo_name not exists."    # 不需要更新最新状态时去掉 pull_update

    # xxx.contributions.log 共 6 列数据
    # $name:    作者姓名
    # $commits: 提交次数
    # $add:     添加行数
    # $subs:    删除行数
    # $changed: 变更行数
    # $active:  总活动行数

    # 使用 --since 和 --until 限定统计范围，将统计结果存入 data 目录中
    # XXX: 可以改成默认取上月，上周，当前月，当前周等

    git log --format='%aN' --since="$since_time" --until="$until_time" | sort | uniq -c | while read -r commits name; do
        echo -en "$name,$commits,";
        git log --since="$since_time" --until="$until_time" --author="$name" --pretty=tformat: --numstat | gawk '{ add += $1; subs += $2; changed += $1 - $2; active += $1 + $2 } END { printf "%s,%s,%s,%s\n", add, subs, changed, active}' -;
    done > "../../../data/${group_name}.${repo_name}.contributions.log"
}

clone_repo # 不需要更新时注释掉
commits_summary
