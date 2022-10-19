////////////////////////////////////////////////////////////////////////////
//
// Copyright 2020 Realm Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
////////////////////////////////////////////////////////////////////////////

#import <Realm/RLMProviderClient.h>

NS_ASSUME_NONNULL_BEGIN

/**
  A client for the username/password authentication provider which
  can be used to obtain a credential for logging in,
  and to perform requests specifically related to the username/password provider.
*/
@interface RLMUsernamePasswordProviderClient : RLMProviderClient

/**
 Registers a new email identity with the username/password provider,
 and sends a confirmation email to the provided address.

 @param email The email address of the user to register.
 @param password The password that the user created for the new username/password identity.
 @param completionHandler A callback to be invoked once the call is complete.
*/

- (void)registerEmail:(NSString *)email
             password:(NSString *)password
           completion:(RLMOptionalErrorBlock)completionHandler;

/**
 Confirms an email identity with the username/password provider.

 @param token The confirmation token that was emailed to the user.
 @param tokenId The confirmation token id that was emailed to the user.
 @param completionHandler A callback to be invoked once the call is complete.
*/
- (void)confirmUser:(NSString *)token
            tokenId:(NSString *)tokenId
         completion:(RLMOptionalErrorBlock)completionHandler;

/**
 Re-sends a confirmation email to a user that has registered but
 not yet confirmed their email address.

 @param email The email address of the user to re-send a confirmation for.
 @param completionHandler A callback to be invoked once the call is complete.
*/
- (void)resendConfirmationEmail:(NSString *)email
                     completion:(RLMOptionalErrorBlock)completionHandler;

/**
 Sends a password reset email to the given email address.

 @param email The email address of the user to send a password reset email for.
 @param completionHandler A callback to be invoked once the call is complete.
*/
- (void)sendResetPasswordEmail:(NSString *)email
                    completion:(RLMOptionalErrorBlock)completionHandler;

/**
 Resets the password of an email identity using the
 password reset token emailed to a user.

 @param password The new password.
 @param token The password reset token that was emailed to the user.
 @param tokenId The password reset token id that was emailed to the user.
 @param completionHandler A callback to be invoked once the call is complete.
*/
- (void)resetPasswordTo:(NSString *)password
                  token:(NSString *)token
                tokenId:(NSString *)tokenId
      completion:(RLMOptionalErrorBlock)completionHandler;

/**
 Resets the password of an email identity using the
 password reset function set up in the application.
 
 TODO: Add an overloaded version of this method that takes
 TODO: raw, non-serialized args.
 
 @param email  The email address of the user.
 @param password The desired new password.
 @param args A pre-serialized list of arguments. Must be a JSON array.
 @param completionHandler A callback to be invoked once the call is complete.
*/
- (void)callResetPasswordFunction:(NSString *)email
                         password:(NSString *)password
                             args:(NSString *)args
                       completion:(RLMOptionalErrorBlock)completionHandler;

@end

NS_ASSUME_NONNULL_END

