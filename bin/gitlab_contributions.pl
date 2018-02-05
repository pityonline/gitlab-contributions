#!/usr/bin/env perl

# TODO:
# 忽略指定群组
# 首次全量获取仓库，之后只获取新增的仓库

use strict;
use warnings;
use utf8;
# use Smart::Comments;

use open ':std', ':encoding(UTF-8)';
use feature 'say';
use Mojo::UserAgent;
use JSON;

my $since_time = shift;
my $until_time = shift;
my $ua = Mojo::UserAgent->new;
my $host = 'https://gitlab.company.com';    # 替换成真实的 gitlab 地址
my $admin_token = "ADMIN_TOKEN_HERE";       # 替换成管理员的 token
my @groups;

sub main {
    # TODO: 群组总数量超过 100 个时需要自动分页取出全部群组
    my $url = "$host/api/v4/groups?per_page=100";
    my $res = $ua->get($url => {'PRIVATE-TOKEN' => "$admin_token"})->res->body;
    my $json = decode_json $res;

    foreach my $group (@$json) {
        my $group_id = $group->{id};
        my $group_name = $group->{name};
        my $projects = get_projects($group_id);

        foreach my $project (@$projects) {
            my $repo_url = $project->{ssh_url_to_repo};
            my $repo_name = $project->{name};
            my $default_branch = $project->{default_branch};

            qx{bash commits_summary.sh $since_time $until_time $group_name $repo_name $repo_url};
        }
    }
}

sub get_projects {
    # TODO: 单一群组内仓库超过 100 个时需要自动分页取出全部仓库
    my $group_id = shift;
    my $url = "$host/api/v4/groups/$group_id/projects?per_page=100";
    my $res = $ua->get($url => {'PRIVATE-TOKEN' => "$admin_token"})->res->body;
    my $json = decode_json $res;
}

main
