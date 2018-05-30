//
//  MAPAddCommentView.m
//  地图
//
//  Created by 崔一鸣 on 2018/2/28.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import "MAPAddCommentView.h"
#import "Masonry.h"

#define Height self.frame.size.height
#define Width self.frame.size.width
#define imageRows self.imageArray.count / 3
#define MaxTextViewLength 140
#define MaxTextFieldLength 10


@implementation MAPAddCommentView
{
    NSString *content;
    UITextField *textField;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        // 初始化地图
        [self initMapView];
        self.backgroundColor = [UIColor whiteColor];
        // 设置瀑布流
        self.layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.itemSize = CGSizeMake(Width / 3 - 30, Width / 3 - 30);
        _layout.minimumLineSpacing = 10;
        _layout.minimumInteritemSpacing = 5;
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 10, Width - 20, Width / 3 - 10) collectionViewLayout:_layout];
        self.collectionView.backgroundColor = [UIColor clearColor];
        [self.collectionView registerClass:[MAPAddCollectionViewCell class] forCellWithReuseIdentifier:@"addCollection"];
        [self.collectionView registerClass:[MAPImageCollectionViewCell class] forCellWithReuseIdentifier:@"imageCollection"];
        _collectionView.scrollEnabled = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        // 设置警告框
        if ([_type isEqual:@"文字"]) {
            self.textAlert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"最多输入%d个字", MaxTextViewLength] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            [_textAlert addAction:sureAction];
        } else {
            self.textAlert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"最多输入%d个字", MaxTextFieldLength] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            [_textAlert addAction:sureAction];
            
            self.titleAlert = [UIAlertController alertControllerWithTitle:@"警告" message:@"标题不能为空" preferredStyle:UIAlertControllerStyleAlert];
            [_titleAlert addAction:sureAction];
        }
        self.postAlert = [UIAlertController alertControllerWithTitle:@"发布评论" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *postAction = [UIAlertAction actionWithTitle:@"发布" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action) {
            if ([_type isEqual:@"文字"]) {
                // 文字评论
                if ([_delegate respondsToSelector:@selector(postTextComment:)]) {
                    [_delegate postTextComment:_commentTextView.text];
                }
            } else if ([_type isEqual:@"图片"]) {
                // 图片评论
                if ([_delegate respondsToSelector:@selector(postImageCommentWithArray:andTitle:)]) {
                    [_delegate postImageCommentWithArray:_imageArray andTitle:textField.text];
                }
            } else if ([_type isEqual:@"语音"]) {
                // 语音评论
              if ([_delegate respondsToSelector:@selector(postAudioComment)]) {
                  [_delegate postAudioComment];
               }
            } else if ([_type isEqual:@"视频"]) {
                // 视频评论
                if ([_delegate respondsToSelector:@selector(postVideoCommentWithTitle:)]) {
                    [_delegate postVideoCommentWithTitle:textField.text];
                }
            }
        }];
        [_postAlert addAction:cancleAction];
        [_postAlert addAction:postAction];
        
        
        // 初始化数组
        self.imageArray = [NSArray<UIImage *> array];
    }
    return self;
}

- (void)initTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.bounds];
    // 设置没有偏移量
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self addSubview:_tableView];
}

- (void)initMapView {
    self.mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, Width, Height * 0.3)];
    // 禁用所有手势
    _mapView.gesturesEnabled = NO;
    // 设置层级
    _mapView.zoomLevel = 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if ([_type isEqual:@"文字"]) {
        static NSString *cellIdentifier = @"commentCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
    } else if ([_type isEqual:@"语音"]) {
        static NSString *cellIdentifier = @"audioCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
    } else {
        static NSString *cellIdentifier = @"tableViewCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 共同拥有的cell
    if (indexPath.section == 0) {
        [cell.contentView addSubview:_mapView];
    } else if (indexPath.section == 1) {
        cell.textLabel.text = _pointName;
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.textLabel.font = [UIFont systemFontOfSize:25];
    } else if (indexPath.section == 3) {
        UIButton *postButton = [[UIButton alloc] init];
        postButton.frame = CGRectMake(0, 0, Width, Height * 0.08);
        [postButton setBackgroundColor:[UIColor colorWithRed:0.95f green:0.54f blue:0.54f alpha:1.00f]];
        [postButton setTitle:@"发 布" forState:UIControlStateNormal];
        [postButton addTarget:self action:@selector(clickPostButton:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:postButton];
    }
    
    // 自身的cell
    if ([_type isEqual:@"文字"]) {
         if (indexPath.section == 2) {
            self.commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 0, Width - 20, Height * 0.52)];
            
            _commentTextView.delegate = self;
            UILabel *placeHolderLabel = [[UILabel alloc] init];placeHolderLabel.text = @"添加评论……";
            placeHolderLabel.numberOfLines = 0;
            placeHolderLabel.textColor = [UIColor lightGrayColor];
            [placeHolderLabel sizeToFit];
            _commentTextView.font = [UIFont systemFontOfSize:17.f];
            placeHolderLabel.font = [UIFont systemFontOfSize:17.f];
            [_commentTextView addSubview:placeHolderLabel];
            
            self.textNumLab = [[UILabel alloc] initWithFrame:CGRectMake(0, Height * 0.47, Width - 20, Height * 0.05)];
            _textNumLab.font = [UIFont systemFontOfSize:17.f];
            _textNumLab.text = [NSString stringWithFormat:@"%d/%d", MaxTextViewLength, MaxTextViewLength];
            _textNumLab.textAlignment = NSTextAlignmentRight;
            _textNumLab.textColor = [UIColor lightGrayColor];
            [_commentTextView addSubview:_textNumLab];
            
            [_commentTextView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
            [cell.contentView addSubview:_commentTextView];
        }
    } else if ([self.type isEqual:@"语音"]) {
        if (indexPath.section == 2) {
            UIButton *record = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, 150, 40)];
            [record setTitle:_audioTime forState:UIControlStateNormal];
            [record setBackgroundColor:[UIColor colorWithRed:0.95f green:0.54f blue:0.54f alpha:0.70f]];
            [record addTarget:self action:@selector(clickRecordButton:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:record];
        }
    } else {
        if (indexPath.section == 2) {
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, Width - 20, 40)];
            titleLabel.text = @"添加标题......";
            titleLabel.textColor = [UIColor blackColor];
            [cell.contentView addSubview:titleLabel];
            
            textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 55, Width - 20, 26)];
            textField.delegate = self;
            textField.layer.borderWidth = 1;
            textField.layer.cornerRadius = 13.0;
            textField.layer.masksToBounds = YES;
            textField.backgroundColor = [UIColor whiteColor];
            textField.layer.borderColor = [UIColor darkGrayColor].CGColor;
            [textField setValue:[NSNumber numberWithInt:10] forKey:@"paddingLeft"];
            [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            [cell.contentView addSubview:textField];
            
            self.textNumLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Width - 50, 26)];
            _textNumLab.font = [UIFont systemFontOfSize:15.f];
            _textNumLab.text = [NSString stringWithFormat:@"0/%d" , MaxTextFieldLength];
            _textNumLab.textAlignment = NSTextAlignmentRight;
            _textNumLab.textColor = [UIColor blackColor];
            [textField addSubview:_textNumLab];
            _collectionView.frame = CGRectMake(10, 100, Width - 20, Height * 0.52 - 110);
            _collectionView.scrollEnabled = YES;
            [cell.contentView addSubview:_collectionView];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *array = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.3], [NSNumber numberWithFloat:0.07], [NSNumber numberWithFloat:0.52], [NSNumber numberWithFloat:0.08], nil];
    return Height * [array[indexPath.section] floatValue];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([_type isEqual:@"视频"]) {
        return 1;
    }
    NSLog(@"--%@--", _type);
    return self.imageArray.count + 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    self.addCollectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"addCollection" forIndexPath:indexPath];
    self.imageCollectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCollection" forIndexPath:indexPath];
    if (self.imageArray.count == 0 || indexPath.item + 1 > (int)self.imageArray.count) {
        [_addCollectionViewCell.button addTarget:self action:@selector(clickAddButton:) forControlEvents:UIControlEventTouchUpInside];
        return _addCollectionViewCell;
    } else {
        _imageCollectionViewCell.imageView.image = self.imageArray[indexPath.item];

        return _imageCollectionViewCell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"点击collection type:%@ _imageArray.count:%lu  row:%d ", _type, (unsigned long)_imageArray.count, (int)indexPath.row);
    if ([_type isEqual:@"视频"] && _imageArray.count == 1 && indexPath.row == 0) {
        // 选择视频 播放视频
        if ([_delegate respondsToSelector:@selector(selectImage)]) {
            [_delegate selectImage];
        }
    }
}

- (void)clickAddButton:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(selectImage)]) {
        [_delegate selectImage];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    //不支持系统表情的输入
    if ([[textView textInputMode] primaryLanguage]==nil||[[[textView textInputMode] primaryLanguage]isEqualToString:@"emoji"]) {
        return NO;
    }
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange =NSMakeRange(startOffset, endOffset - startOffset);
        if (offsetRange.location < MaxTextViewLength) {
            return YES;
        } else {
            if ([_delegate respondsToSelector:@selector(popTextAlertController)]) {
                [_delegate popTextAlertController];
            }
            return NO;
        }
    }
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger caninputlen = MaxTextViewLength - comcatstr.length;
    if (caninputlen >= 0){
        return YES;
    } else {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0, MAX(len, 0)};
        if (rg.length > 0) {
            NSString *s = @"";
            //判断是否只普通的字符或asc码(对于中文和表情返回NO)
            BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
            if (asc) {
                s = [text substringWithRange:rg]; //因为是ascii码直接取就可以了不会错
            } else {
                __block NSInteger idx =0;
                __block NSString  *trimString =@"";//截取出的字串
                //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
                [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
                                         options:NSStringEnumerationByComposedCharacterSequences
                                      usingBlock: ^(NSString* substring,NSRange substringRange,NSRange enclosingRange,BOOL* stop) {
                                          if (idx >= rg.length) {
                                              *stop = YES;//取出所需要就break，提高效率
                                              return ;
                                          }
                                          trimString = [trimString stringByAppendingString:substring];
                                          idx++;
                                      }];
                s = trimString;
            }
            //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            //既然是超出部分截取了，哪一定是最大限制了。
            self.textNumLab.text = [NSString stringWithFormat:@"%d/%ld",0,(long)MaxTextViewLength];
        }
        if ([_delegate respondsToSelector:@selector(popTextAlertController)]) {
            [_delegate popTextAlertController];
        }
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    if (existTextNum > MaxTextViewLength){
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        content = [nsTextContent substringToIndex:MaxTextViewLength];
        [textView setText:content];
    }
    //不让显示负数
    self.textNumLab.text = [NSString stringWithFormat:@"%ld/%d", MAX(0, MaxTextViewLength - existTextNum), MaxTextViewLength];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //不支持系统表情的输入
    if ([[textField textInputMode] primaryLanguage]==nil||[[[textField textInputMode] primaryLanguage]isEqualToString:@"emoji"]) {
        return NO;
    }
    UITextRange *selectedRange = [textField markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textField positionFromPosition:selectedRange.start offset:0];
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textField offsetFromPosition:textField.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textField offsetFromPosition:textField.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange =NSMakeRange(startOffset, endOffset - startOffset);
        if (offsetRange.location < MaxTextFieldLength) {
            return YES;
        } else {
            if ([_delegate respondsToSelector:@selector(popTextAlertController)]) {
                [_delegate popTextAlertController];
            }
            return NO;
        }
    }
    NSString *comcatstr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSInteger caninputlen = MaxTextFieldLength - comcatstr.length;
    if (caninputlen >= 0){
        return YES;
    } else {
        NSInteger len = string.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0, MAX(len, 0)};
        if (rg.length > 0) {
            NSString *s = @"";
            //判断是否只普通的字符或asc码(对于中文和表情返回NO)
            BOOL asc = [string canBeConvertedToEncoding:NSASCIIStringEncoding];
            if (asc) {
                s = [string substringWithRange:rg]; //因为是ascii码直接取就可以了不会错
            } else {
                __block NSInteger idx =0;
                __block NSString  *trimString =@"";//截取出的字串
                //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
                [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                                         options:NSStringEnumerationByComposedCharacterSequences
                                      usingBlock: ^(NSString* substring,NSRange substringRange,NSRange enclosingRange,BOOL* stop) {
                                          if (idx >= rg.length) {
                                              *stop = YES;//取出所需要就break，提高效率
                                              return ;
                                          }
                                          trimString = [trimString stringByAppendingString:substring];
                                          idx++;
                                      }];
                s = trimString;
            }
            //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
            [textField setText:[textField.text stringByReplacingCharactersInRange:range withString:s]];
            //既然是超出部分截取了，哪一定是最大限制了。
            self.textNumLab.text = [NSString stringWithFormat:@"%d/%ld", 0, (long)MaxTextFieldLength];
        }
        if ([_delegate respondsToSelector:@selector(popTextAlertController)]) {
            [_delegate popTextAlertController];
        }
        return NO;
    }
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField {
    UITextRange *selectedRange = [textField markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textField positionFromPosition:selectedRange.start offset:0];
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    NSString  *nsTextContent = textField.text;
    NSInteger existTextNum = nsTextContent.length;
    if (existTextNum > MaxTextFieldLength){
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        content = [nsTextContent substringToIndex:MaxTextFieldLength];
        [textField setText:content];
    }
    //不让显示负数
    self.textNumLab.text = [NSString stringWithFormat:@"%ld/%d", MAX(0, existTextNum), MaxTextFieldLength];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor blackColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)clickPostButton:(UIButton *)sender {
    NSLog(@"%@", textField.text);
    if ([textField.text isEqual:@""]) {
        if ([_delegate respondsToSelector:@selector(popTitleAlertController)]) {
            [_delegate popTitleAlertController];
        }
    } else {
        if ([_delegate respondsToSelector:@selector(popPostAlertController)]) {
            [_delegate popPostAlertController];
        }
    }
}

- (void)clickRecordButton:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(playAudioWithUrl)]) {
        [_delegate playAudioWithUrl];
    }
}

@end
