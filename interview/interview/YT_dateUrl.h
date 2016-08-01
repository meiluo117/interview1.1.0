//
//  YT_dateUrl.h
//  interview
//
//  Created by Mickey on 16/5/16.
//  Copyright © 2016年 于波. All rights reserved.
//

#ifndef YT_dateUrl_h
#define YT_dateUrl_h
//[NSString stringWithFormat:@"%@/api/v1/investor/makesure/clickable",YT_Main_URL]
/**
 *  约谈（创业者）第一步创建项目
 * http://localhost:8084/chxp-apnt/api/v1/investor/process/founder/project?projectId=1110&projectName=测试流程&city=1&industry=1&stage=1&logo&url&introduce=介绍&apntTeamIntro=团队信息&bp&bpName&investorId=176724&logo=
 */
#define Url_Date_CreateItem [NSString stringWithFormat:@"%@/api/v1/investor/process/founder/project",YT_Main_URL]

/**
 *  投资人接受，点击接受，输入时间和地点，调用接口
 *  http://localhost:8084/chxp-apnt/api/v1/investor/process/investor/accept?accept=1&orderId=7&time=2016-05-16 14:08:01&address=测试地址
 */
#define Url_Date_InvestorAccept [NSString stringWithFormat:@"%@/api/v1/investor/process/investor/accept",YT_Main_URL]

/**
 *  优惠码
 *  http://localhost:8084/chxp-apnt/api/v1/investor/validdiscountcode?code=sssz&orderId=7
 */
#define Url_Date_salesCode [NSString stringWithFormat:@"%@/api/v1/investor/validdiscountcode",YT_Main_URL]

/**
 *  投资人确认见过面 status为4
 *  http://localhost:8084/chxp-apnt/api/v1/investor/process/investor/makesure?type=1&orderId=7
 */
#define Url_Date_InvestorSureMeet [NSString stringWithFormat:@"%@/api/v1/investor/process/investor/makesure",YT_Main_URL]

/**
 *  创业者评价约谈stauts 为5
 *  http://localhost:8084/chxp-apnt/api/v1/investor/process/founder/evaluate?star=4&content=还行&orderId=7
 */
#define Url_Date_CreateCommentDate [NSString stringWithFormat:@"%@/api/v1/investor/process/founder/evaluate",YT_Main_URL]

/**
 *  创业者\投资人，订单信息，通过token区分
 *  ttp://localhost:8084/chxp-apnt/api/v1/investor/process/info?orderId=3
 */
#define Url_Date_CreateOrder [NSString stringWithFormat:@"%@/api/v1/investor/process/info",YT_Main_URL]

/**
 *  约谈列表页（左右滑动）
 *  http://localhost:8084/chxp-apnt/api/v1/investor/process/investor/projects?type=2&status=1&page=1
 *
 * type1创业者2投资人 status 分为1、2与1、2、3对应状态
 *
 * status为123 | 4 | >5对应投资人的三种状态 status为1234 | >5对应创业者的两种种状态
 */
#define Url_Date_list [NSString stringWithFormat:@"%@/api/v1/investor/process/investor/projects",YT_Main_URL]

/**
 *  确认预约投资人订单是否全部完成的接口（是否可以预约）
 *  http://localhost:8084/chxp-apnt/api/v1/investor/makesure/clickable?userId=176724
 */
#define Url_Date_OrderIsFinish [NSString stringWithFormat:@"%@/api/v1/investor/makesure/clickable",YT_Main_URL]

#endif /* YT_dateUrl_h */
