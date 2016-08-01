//
//  YT_OtherUrl.h
//  interview
//
//  Created by Mickey on 16/6/3.
//  Copyright © 2016年 于波. All rights reserved.
//

#ifndef YT_OtherUrl_h
#define YT_OtherUrl_h
//[NSString stringWithFormat:@"%@/wap/downloadapp",YT_Main_URL]

/*****************************阿里支付***********************/
/**
 *  支付宝签名 http://localhost:8084/chxp-apnt/api/v1/ali/sign?orderId=7
 */
#define Url_AliPay_Signiture [NSString stringWithFormat:@"%@/api/v1/ali/sign",YT_Main_URL]

/**
 *  支付成功，向后台确认 http://localhost:8084/chxp-apnt/api/v1/investor/makesure/payment?orderId=7
 */
#define Url_AliPay_AgainSure [NSString stringWithFormat:@"%@/api/v1/investor/makesure/payment",YT_Main_URL]

/*****************************阿里支付***********************/

/*****************************友盟分享/推送***********************/
#define umengAppKey @"5760b9fce0f55a9438001655"
//qq
#define QQWithAppId @"1105024996"
#define QQWithAppKey @"qtKJigTZMdWvvNYM"
#define QQWithUrl YT_Main_URL

//微信
#define WXAppId @"wx524b7b27b9d83e58"
#define WXAppSecret @"939734266a67e0be6c9c311ecf3cb22f"
#define WXWithUrl YT_Main_URL

#define sharedDetail @"想融资，上约谈。下载约谈app，轻轻松松约见投资人。"
#define sharedTitle @"约谈"
#define sharedUrl YT_Main_URL

#define sharedHotInvestorTitle @"【约谈】%@(%@，%@)"
#define sharedHotInvestorDetail @"我在约谈app发现一个靠谱的投资人，推荐给你。"

//推送别名
#define PushAlias @"product"//product//beta
/*****************************友盟分享/推送***********************/
/**
 *  “我”分享下载app
 */
#define sharedDownloadAPP [NSString stringWithFormat:@"%@/wap/downloadapp",YT_Main_URL]

/**
 *  分享投资人 网页带下载
 */
#define sharedInvestor_HTML @"http://www.talk2vc.com/wap/investor?userId=%@"

/*****************************友盟分享***********************/

#endif /* YT_OtherUrl_h */
