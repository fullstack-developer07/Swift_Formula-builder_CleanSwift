/*************************************************************************
 *
 * Copyright 2016 Realm Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 **************************************************************************/

#ifndef REALM_UTIL_TERMINATE_HPP
#define REALM_UTIL_TERMINATE_HPP

#include <cstdlib>

#include <realm/util/features.h>
#include <realm/util/to_string.hpp>
#include <realm/version.hpp>

#define REALM_TERMINATE(msg) realm::util::terminate((msg), __FILE__, __LINE__)

namespace realm {
namespace util {
/// Install a custom termination notification callback. This will only be called as a result of
/// Realm crashing internally, i.e. a failed assertion or an otherwise irrecoverable error
/// condition. The termination notification callback is supplied with a zero-terminated string
/// containing information relevant for debugging the issue leading to the crash.
///
/// The termination notification callback is shared by all threads, which is another way of saying
/// that it must be reentrant, in case multiple threads crash simultaneously.
///
/// Furthermore, the provided callback must be `noexcept`, indicating that if an exception
/// is thrown in the callback, the process is terminated with a call to `std::terminate`.
void set_termination_notification_callback(void (*callback)(const char* message) noexcept) noexcept;

REALM_NORETURN void terminate(const char* message, const char* file, long line,
                              std::initializer_list<Printable>&& = {}) noexcept;
REALM_NORETURN void terminate_with_info(const char* message, const char* file, long line,
                                        const char* interesting_names,
                                        std::initializer_list<Printable>&& = {}) noexcept;

// LCOV_EXCL_START
template <class... Ts>
REALM_NORETURN void terminate(const char* message, const char* file, long line, Ts... infos) noexcept
{
    static_assert(sizeof...(infos) == 2 || sizeof...(infos) == 4 || sizeof...(infos) == 6,
                  "Called realm::util::terminate() with wrong number of arguments");
    terminate(message, file, line, {Printable(infos)...});
}

template <class... Args>
REALM_NORETURN void terminate_with_info(const char* assert_message, int line, const char* file,
                                        const char* interesting_names, Args&&... interesting_values) noexcept
{
    terminate_with_info(assert_message, file, line, interesting_names, {Printable(interesting_values)...});
}
// LCOV_EXCL_STOP

} // namespace util
} // namespace realm

#endif // REALM_UTIL_TERMINATE_HPP
